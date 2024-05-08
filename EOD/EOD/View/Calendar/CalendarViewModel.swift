//
//  CalendarViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var date: Date = Date() // 우선 오늘 날짜로 세팅
}
