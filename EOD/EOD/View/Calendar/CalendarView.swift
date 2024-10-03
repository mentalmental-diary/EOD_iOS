//
//  CalendarView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.showMonthSelectModalView = true
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
            
            let daysInMonth = days(for: viewModel.date)
            let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
            
            Spacer().frame(height: 21)
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                // 요일 헤더
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(size: 16)
                        .foregroundColor(Color.black)
                }
            }
            
            Spacer().frame(height: 12)
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: daysInMonth.count > 35 ? 22 : 26) {
                
                // 날짜 그리드
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, day in
                    CalendarCellView(day: day)
                        .onTapGesture {
                            if day != 0 {
                                if let date = getDateForCell(day: day, month: viewModel.date.month, year: viewModel.date.year) {
                                    viewModel.selectDate = date
                                }
                            }
                        }
                }
            }
            
            Spacer().frame(height: 24)
            
            diaryView()
                .shadow(color: Color(red: 242/255, green: 242/255, blue: 229/255), radius: 17, x: 0, y: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 44)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .toast(message: "일기가 저장되었어요!", visibleIcon: true, isShowing: $viewModel.isToast)
        .background(UIColor.CommonBackground.background.color)
    }
}

// MARK: - ViewBuilder
extension CalendarView {
    @ViewBuilder func diaryView() -> some View {
        VStack {
            HStack(spacing: 0) {
                Text(currentDiaryDay)
                    .font(size: 16)
                    .foregroundColor(UIColor.Gray.gray900.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if viewModel.existDiaryContents {
                    Button(action: {
                        // TODO: 수정 액션 구현
                    }, label: {
                        Image("icon_edit")
                    })
                    
                    Spacer().frame(width: 8)
                    
                    Button(action: {
                        // TODO: 삭제 액션 구현
                    }, label: {
                        Image("icon_delete")
                    })
                }
            }
            
            VStack {
                Spacer()
                
                Image("icon_basic")
                
                EmptyDiaryText(text: viewModel.emptyDiaryText)
                    .foregroundColor(Color.black)
                
                if viewModel.selectDate != nil {
                    Button(action: {
                        viewModel.showDiaryViewAction()
                    }, label: {
                        Text("일기쓰기")
                            .font(size: 14)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 28.5)
                            .padding(.vertical, 12.0)
                            .background(Color.black)
                            .cornerRadius(6.0)
                    })
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(17.0)
            
        }
    }
    
    @ViewBuilder func EmptyDiaryText(text: String) -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .frame(width: 119, height: 5)
                .foregroundColor(UIColor.Yellow.yellow200.color)
            
            Text(text)
                .font(size: 16)
        }
    }
}

// MARK: - Variable
extension CalendarView {
    private var currentDiaryDay: String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "M월 dd일 EEEE"
        dateFormmater.locale = Locale(identifier: "ko_KR")
        
        if viewModel.selectDate != nil {
            let dateString = dateFormmater.string(from: viewModel.selectDate ?? Date())
            
            return dateString
        } else {
            return ""
        }
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
        
        return days
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter.string(from: date)
    }
    
    func getDateForCell(day: Int, month: Int, year: Int) -> Date? {
        if day == 0 { return nil }
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return viewModel.calendar.date(from: components)
    }
}

#Preview {
    CalendarView(viewModel: CalendarViewModel())
}
