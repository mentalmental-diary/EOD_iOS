//
//  MainTabView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TabView()
                    .frame(maxHeight: geo.size.height)
                    .frame(width: geo.size.width)
                
                HStack(spacing: 0) {
                    TabButton(tab: .Home)
                    TabButton(tab: .Calender)
                    TabButton(tab: .Report)
                    TabButton(tab: .Setting)
                }
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.bottom)
                .background(
                    Color.white
                        .ignoresSafeArea(.container, edges: .bottom)
                )
                
                Spacer().frame(height: geo.safeAreaInsets.bottom)
            }
            .frame(width: geo.size.width, height: geo.size.height + geo.safeAreaInsets.bottom)
        }
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
            Text(tab.rawValue) // TODO: 향후 디자인 가이드에 맞게 이미지로 변경할 예정
                .frame(maxWidth: .infinity)
        })
    }
    
    @ViewBuilder
    func TabView() -> some View {
        switch viewModel.currentTab {
        case .Home:
            HomeView()
        case .Calender: // TODO: 임시로 뷰 지정 -> 차후 개발될때마다 변경
            CalendarView()
        case .Report:
            HomeView()
        case .Setting:
            HomeView()
        }
    }
}

#Preview {
    var viewModel: MainViewModel = MainViewModel()
    return MainTabView(viewModel: viewModel)
}
