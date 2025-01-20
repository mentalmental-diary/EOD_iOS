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
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: daysInMonth.count > 35 ? 8 : 12) {
                
                // 날짜 그리드
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, day in
                    CalendarCellView(day: day, calendarDate: $viewModel.date, diaryInfo: viewModel.diarySummaryList[day] ?? nil, selectDay: viewModel.selectDate)
                        .onTapGesture {
                            if day != 0 {
                                if let date = getDateForCell(day: day, month: viewModel.date.month, year: viewModel.date.year) {
                                    viewModel.selectDate = date
                                }
                            }
                        }
                }
            }
            
            Spacer().frame(height: 44)
            
            diaryView()
                .shadow(color: Color(red: 242/255, green: 242/255, blue: 229/255), radius: 17, x: 0, y: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 44)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .toast(message: viewModel.toastMessage, visibleIcon: true, isShowing: $viewModel.isToast)
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
                
                if viewModel.visibleDiaryIcon {
                    Button(action: {
                        viewModel.modifyDiaryAction()
                    }, label: {
                        Image("icon_edit")
                    })
                    
                    Spacer().frame(width: 8)
                    
                    Button(action: {
                        viewModel.deleteDiary()
                    }, label: {
                        Image("icon_delete")
                    })
                }
            }
            
            summaryDiaryView()
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
    
    private func summaryDiaryView() -> some View {
        VStack {
            if emptySelectedDateContent {
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
            } else {
                HStack(spacing: 0) {
                    Image(viewModel.selectedDiaryInfo?.emotion.imageName ?? "")
                    
                    Spacer().frame(width: 14)
                    
                    Text(viewModel.selectedDiaryInfo?.emotion.description ?? "")
                        .font(size: 20)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets.init())
                        .background(
                            GeometryReader { geometry in
                                UIColor.Yellow.yellow200.color
                                    .frame(width: geometry.size.width, height: 8)
                                    .offset(x: 0, y: geometry.size.height - 8)
                            }
                        )
                    
                    Spacer()
                }
                
                Spacer().frame(height: 12)
                
                Text(viewModel.selectedDiaryInfo?.content ?? "")
                    .font(size: 18)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color.white)
        .cornerRadius(17.0)
    }
}

// MARK: - Variable
extension CalendarView {
    private var currentDiaryDay: String {
        guard let selectedDate = viewModel.selectDate else { return "" }
        
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "M월 dd일 EEEE"
        dateFormmater.locale = Locale(identifier: "ko_KR")
        
        return dateFormmater.string(from: selectedDate)
    }
    
    /// 해당 날짜에 저장된 일기 내용 존재 여부
    /// 일기 내용이 없는 경우 true
    private var emptySelectedDateContent: Bool {
        if viewModel.selectedDiaryInfo != nil { // 날짜가 선택되있으면서 해당 날짜에 데이터가 있는 경우 false
            return false
        } else { // 날짜 미선택 또는 해당 날짜에 데이터가 없는경우 true
            return true
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
