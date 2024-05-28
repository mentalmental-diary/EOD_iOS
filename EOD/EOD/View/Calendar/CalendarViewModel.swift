//
//  CalendarViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var date: Date = Date() // 우선 오늘 날짜로 세팅
    
    @Published var selectDate: Date = Date() // 현재 선택된 날짜 -> 초기값은 오늘날짜
    
    let calendar = Calendar.current
}

extension CalendarViewModel {
    func setCalendarDate(year: Int, month: Int) {
        var components = self.calendar.dateComponents([.year, .month], from: self.date)
        components.year = year
        components.month = month
        self.date = self.calendar.date(from: components) ?? Date()
    }
}
