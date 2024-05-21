//
//  CalendarView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel = CalendarViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    HStack(spacing: 4) {
                        Text(monthYearString(from: viewModel.date))
                            .font(size: 26)
                            .foregroundColor(Color.black)
                        Image("polygon")
                    }
                })
                Spacer()
            }
            .padding()
            
            let daysInMonth = days(for: viewModel.date)
            let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(size: 16)
                }
                
                // 날짜 그리드
                ForEach(daysInMonth, id: \.self) { day in
                    CalendarCellView(day: day)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Function
extension CalendarView {
    func days(for date: Date) -> [Int] {
        var days: [Int] = []
        let range = viewModel.calendar.range(of: .day, in: .month, for: date)
        
        // 해당 월의 첫 날로 이동
        let startOfMonth = viewModel.calendar.date(from: viewModel.calendar.dateComponents([.year, .month], from: date)) ?? Date()
        let firstDayIndex = viewModel.calendar.component(.weekday, from: startOfMonth) - 1
        
        // 첫 주를 빈 칸으로 채우기
        days.append(contentsOf: Array(repeating: 0, count: firstDayIndex))
        
        // 해당 월의 일수 추가
        if let range = range {
            days.append(contentsOf: range)
        }
        
        // 마지막으로 남은 공간을 빈 칸으로 채워 6주 레이아웃 확보
        let totalDays = days.count
        let totalSlots = 7 * 6
        if totalDays < totalSlots {
            days.append(contentsOf: Array(repeating: 0, count: totalSlots - totalDays))
        }
        
        return days
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
}
