//
//  MonthSelectModalView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/9/24.
//

import SwiftUI

struct MonthSelectModalView: View {
    
    @State var appearAnimation: Bool = false
    @ObservedObject var viewModel: CalendarViewModel
    @State var selectYear: Int
    @Binding var showModalView: Bool
    
    init(viewModel: CalendarViewModel, showModalView: Binding<Bool>) {
        self.viewModel = viewModel
        self.selectYear = viewModel.date.year
        self._showModalView = showModalView
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // dimmed View
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(appearAnimation ? 0.3 : 0.0))
                    .zIndex(-1)
                    .onTapGesture {
                        dismissWithAnimation()
                    }
                
                if appearAnimation {
                    VStack(spacing: 0) {
                        Color(.white)
                            .frame(height: 20.0)
                            .zIndex(1)
                        
                        monthSelectView(geometry: geometry)
                            .background(Color.white)
                    }
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(corners: [.topLeft, .topRight], radius: 20)
                    
                }
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: 0.2)) {
                   appearAnimation = true
                }
            })
        }
    }
    
    private func dismissWithAnimation() {
        withAnimation(.easeOut(duration: 0.2)) {
            appearAnimation = false
            showModalView = false
        }
    }
}

/// Variable
extension MonthSelectModalView {
    // 월 선택 부분
    private var months: [String] {
        return ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    }
}

/// Function
extension MonthSelectModalView {
    /// 현재 선택되있는 달인지 체크
    private func checkSelectMonth(month: Int) -> Bool {
        if self.viewModel.date.year == self.selectYear && self.viewModel.date.month == month {
            return true
        } else {
             return false
        }
    }
}

/// ViewBuilder
extension MonthSelectModalView {
    @ViewBuilder func monthSelectView(geometry: GeometryProxy) -> some View {
        VStack {
            HStack {
                Text("월 선택")
                    .font(size: 22)
                    .foregroundColor(UIColor.Gray.gray900.color)
                
                Spacer()
                
                Button(action: {
                    viewModel.date = Date()
                    viewModel.selectDate = Date()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        dismissWithAnimation()
                    })
                }, label: {
                    Text("오늘로 이동")
                        .font(size: 16.0)
                        .foregroundColor(Color.white)
                })
                .padding(EdgeInsets(top: 8.0, leading: 12.0, bottom: 8.0, trailing: 12.0))
                .background(Color.black)
                .cornerRadius(6.0)
                
                Spacer().frame(width: 16)
                
                Button(action: {
                    dismissWithAnimation()
                }, label: {
                    Image("btn_close")
                })
            }
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 36)
            
            selectView()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, geometry.safeAreaInsets.bottom)
    }
    
    @ViewBuilder func selectView() -> some View {
        VStack {
            HStack {
                Button(action: {
                    // 이전 년도로 이동
                    self.selectYear -= 1
                }) {
                    Image("btn_left")
                }
                
                Spacer()
                
                Text("\(self.selectYear.string)년")
                    .font(size: 22.0)
                    .foregroundColor(Color.black)
                
                Spacer()
                
                Button(action: {
                    self.selectYear += 1
                }) {
                    Image("btn_right")
                }
            }
            
            Spacer().frame(height: 30)
            
            VStack(spacing: 16) {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<4) { col in
                            let month = row * 4 + col + 1
                            Button(action: {
                                viewModel.setCalendarDate(year: selectYear, month: month)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                    dismissWithAnimation()
                                })
                                
                            }) {
                                Text(months[month - 1])
                                    .font(size: 20)
                                    .frame(width: 46, height: 46)
                                    .foregroundColor(Color.black)
                                    .background(checkSelectMonth(month: month) ? UIColor.Yellow.yellow100.color : Color.clear)
                                    .clipShape(Circle())
                            }
                            
                            if col < 3 {
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    MonthSelectModalView(viewModel: CalendarViewModel(), showModalView: .constant(true))
}
