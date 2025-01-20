//
//  CalendarViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var date: Date = Date() {
        didSet {
            fetchMonthDiary()
        }
    }
    @Published var selectDate: Date? = nil // 현재 선택된 날짜
    @Published var selectEmotionType: EmotionType?
    @Published var isToast: Bool = false
    @Published var showEmotionSelectView: Bool = false
    @Published var diary: Diary = Diary()
    @Published var isShowAlert: Bool = false
    @Published var showDiaryView: Bool = false
    @Published var showMonthSelectModalView: Bool = false
    
    private var networkModel: CalendarNetworkModel = CalendarNetworkModel()
    
    var original: Diary? // 수정진입 최초 일기 정보
    
    var diaryList: [Diary]? // TODO: 캘린더 데이터 구조를 어떻게 만들지 결정
    
    var diarySummaryList: [Int: DiarySummary?] = [:]
    
    var toastMessage: String = ""
    
    let calendar = Calendar.current
    
    init() {
        fetchMonthDiary()
    }
}

/// Var
extension CalendarViewModel {
    var emptyDiaryText: String { return selectDate == nil ? "날짜를 선택해주세요" : "작성한 일기가 없어요" }
    
    var visibleDiaryIcon: Bool {
        let selectDay = selectDate?.day ?? 0
        if diarySummaryList[selectDay] != nil { // 해당 날짜에 정보가 있기 때문에 컨텐츠가 있다 생각하고 false반환
            return true
        } else {
            return false
        }
    }
    
    var isModify: Bool { return original != nil }
    
    var isModified: Bool {
        guard isModify else { return true }
        
        return original != diary
    }
    
    var selectedDiaryInfo: DiarySummary? {
        guard let day = self.selectDate?.day else { return nil }
        
        return diarySummaryList[day] ?? nil
    }
}

/// Func
extension CalendarViewModel {
    func setCalendarDate(year: Int, month: Int) {
        var components = self.calendar.dateComponents([.year, .month], from: self.date)
        components.year = year
        components.month = month
        self.date = self.calendar.date(from: components) ?? Date()
        self.selectDate = nil
    }
    
    func showDiaryViewAction() {
        self.showDiaryView = true
        self.showEmotionSelectView = self.diary.emotion == nil
        if self.diary.writeDate == nil {
            self.diary.writeDate = self.selectDate
        }
    }
    
    func resetData() {
        self.original = nil
        self.diary = Diary()
    }
    
    func groupEntriesByDay(diarySummaryList: [DiarySummary]) -> [Int: DiarySummary?] { // TODO: 네이밍 변경, 기능 확인
        var groupedEntries = [Int: DiarySummary?]()
        
        // 해당 월의 총 일수 계산
        guard let range = calendar.range(of: .day, in: .month, for: self.date) else {
            return groupedEntries
        }
        
        // 해당 월의 모든 날짜를 nil로 초기화
        for day in range {
            groupedEntries[day] = nil
        }
        
        for entry in diarySummaryList {
            // 일기를 작성한 날짜의 '일(day)' 값을 가져옴
            guard let day = entry.writeDate?.day else { continue }
            
            groupedEntries[day] = entry
        }
        
        return groupedEntries
    }
    
    private func fetchMonthDiary() {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let yearMonth = String(format: "%04d-%02d", year, month)

        networkModel.fetchMonthDiary(yearMonth: yearMonth, completion: { [weak self] result in
            debugLog("월 달력 정보 호출 API완료 result: \(result)")
            switch result {
            case .success(let summaryModel):
                self?.diarySummaryList = self?.groupEntriesByDay(diarySummaryList: summaryModel) ?? [:]
                
                debugLog("호출된 정보 확인 : \(summaryModel)")
            case .failure(let error):
                warningLog("월 달력 정보 호출 API 실패 error: \(error)")
            }
        })
    }
    
    func modifyDiaryAction() {
        self.fetchDayDiary()
    }
    
    /// 특정 날짜 다이어리 정보 받아오기
    private func fetchDayDiary() {
        guard let date = self.selectDate, let summary = diarySummaryList[date.day], let id = summary?.id else { errorLog("선택된 날짜에 해당하는 다이어리 정보가 없습니다."); return }
        
        networkModel.fetchDayDiary(id: id, completion: { [weak self] result in
            switch result {
            case .success(let diary):
                debugLog("해당 날짜에 해당하는 다이어리 정보 호출 성공 diary: \(diary)")
                self?.diary = diary
                self?.original = diary
                self?.showDiaryViewAction()
            case .failure(let error):
                errorLog("해당 날짜에 해당하는 다이어리 정보 호출 실패. error: \(error)")
                self?.toastMessage = "수정 진입 실패"
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
            }
        })
    }
    
    func uploadDiary() {
        networkModel.uploadDiary(uploadDiary: diary, completion: { [weak self] result in
            debugLog("업로드 API완료 result: \(result)")
            guard let error = result.error else {
                self?.showDiaryView = false
                self?.toastMessage = "일기가 저장되었어요!"
                self?.fetchMonthDiary()
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
                return
            }
            
            self?.toastMessage = "일기 저장시 오류가 발생했습니다. error: \(error)"
            withAnimation(.easeInOut(duration: 0.6)) {
                self?.isToast = true
            }
        })
        
    }
    
    func modifyDiary() {
        guard isModified else { return }
        networkModel.modifyDiary(modifyDiary: diary, completion: { [weak self] result in
            debugLog("다이어리 수정 API완료 result: \(result)")
            guard let error = result.error else {
                self?.showDiaryView = false
                self?.toastMessage = "일기가 저장되었어요!"
                self?.fetchMonthDiary()
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
                return
            }
            
            self?.toastMessage = "일기 저장시 오류가 발생했습니다. error: \(error)"
            withAnimation(.easeInOut(duration: 0.6)) {
                self?.isToast = true
            }
        })
    }
    
    func deleteDiary() {
        guard let date = self.selectDate, let summary = diarySummaryList[date.day], let id = summary?.id else { errorLog("선택된 날짜에 해당하는 다이어리 정보가 없습니다."); return }
        
        networkModel.deleteDiary(id: id, completion: { [weak self] result in
            switch result {
            case .success:
                infoLog("다이어리 삭제 API 성공")
                self?.fetchMonthDiary()
                self?.toastMessage = "일기가 삭제되었습니다."
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
            case .failure(let error):
                errorLog("다이어리 삭제 API실패. error: \(error)")
            }
        })
    }
}
