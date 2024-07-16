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
    
    var diaryList: [Diary]? // TODO: 캘린더 데이터 구조를 어떻게 만들지 결정
    
    let calendar = Calendar.current
}

/// Var
extension CalendarViewModel {
    var emptyDiaryText: String { return selectDate == nil ? "날짜를 선택해주세요" : "작성한 일기가 없어요" }
    
    var existDiaryContents: Bool { return false } // TODO: 일단 임시로 false로 하드코딩
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
}
