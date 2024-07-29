//
//  MainTabView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainViewModel
    @StateObject private var calendarViewModel = CalendarViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TabView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(spacing: 0) {
                    TabButton(tab: .Home)
                    TabButton(tab: .Calender)
                    TabButton(tab: .Game)
                    TabButton(tab: .Shop)
                    TabButton(tab: .My)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, geo.safeAreaInsets.bottom)
                .padding(.top, 12)
                .background(.white)
                .edgesIgnoringSafeArea(.bottom)
                .shadow(color: Color(red: 242/255, green: 242/255, blue: 229/255), radius: 17, x: 0, y: -1)
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .ignoresSafeArea(.keyboard)
        .background(UIColor.CommonBackground.background.color)
    }
}

/// ViewBuilder
extension MainTabView {
    @ViewBuilder
    func TabButton(tab: Tab) -> some View {
        Button(action: {
            withAnimation {
                viewModel.currentTab = tab
            }
        }, label: {
            VStack {
                Image(tab.iconName)
                    .renderingMode(viewModel.currentTab == tab ? .template : .original)
                    .foregroundColor(viewModel.currentTab == tab ? .black : nil)
                
                Text(tab.title)
                    .font(size: 14)
                    .foregroundColor(viewModel.currentTab == tab ? .black : UIColor.Gray.gray300.color)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        })
    }
    
    @ViewBuilder
    func TabView() -> some View {
        switch viewModel.currentTab {
        case .Home:
            HomeView()
        case .Calender: // TODO: 임시로 뷰 지정 -> 차후 개발될때마다 변경
            CalendarView(viewModel: calendarViewModel)
        case .Game:
            HomeView()
        case .Shop:
            HomeView()
        case .My:
            MyPageView(viewModel: viewModel)
        }
    }
}

#Preview {
    var viewModel: MainViewModel = MainViewModel()
    return MainTabView(viewModel: viewModel)
}
