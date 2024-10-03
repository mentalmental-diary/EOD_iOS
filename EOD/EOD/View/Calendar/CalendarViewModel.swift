//
//  CalendarViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var date: Date = Date() // 우선 오늘 날짜로 세팅
    @Published var selectDate: Date? = Date() // 현재 선택된 날짜 -> 초기값은 오늘날짜
    @Published var selectEmotionType: EmotionType?
    @Published var isToast: Bool = false
    @Published var showEmotionSelectView: Bool = false
    @Published var diary: Diary = Diary()
    @Published var isShowAlert: Bool = false
    @Published var showDiaryView: Bool = false
    @Published var showMonthSelectModalView: Bool = false
    
    private var networkModel: CalendarNetworkModel = CalendarNetworkModel()
    
    private var uploadDiary: Diary?
    
    var original: Diary? // 수정진입이 최초 일기 정보
    
    var diaryList: [Diary]? // TODO: 캘린더 데이터 구조를 어떻게 만들지 결정
    
    var diarySummaryList: [DiarySummary]?
    
    let calendar = Calendar.current
    
    init() {
        fetchMonthDiary()
    }
}

/// Var
extension CalendarViewModel {
    var emptyDiaryText: String { return selectDate == nil ? "날짜를 선택해주세요" : "작성한 일기가 없어요" }
    
    var existDiaryContents: Bool { return false } // TODO: 일단 임시로 false로 하드코딩
    
    var isModify: Bool { return original != nil }
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
        self.diary.writeDate = self.date
    }
    
    private func fetchMonthDiary() {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let yearMonth = String(format: "%04d%02d", year, month)

        networkModel.fetchMonthDiary(yearMonth: yearMonth, completion: { [weak self] result in
            debugLog("월 달력 정보 호출 API완료 result: \(result)")
            switch result {
            case .success(let summaryModel):
                self?.diarySummaryList = summaryModel.list
                
                debugLog("호출된 정보 확인 : \(summaryModel.list)")
            case .failure(_):
                break
            }
        })
    }
    
    func uploadDiaryAction() {
        
    }
}
