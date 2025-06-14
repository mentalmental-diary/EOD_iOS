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
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var settingViewModel: SettingViewModel = SettingViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var showPasswordInputView = true
    
    var body: some View {
        NavigationView(content: {
            GeometryReader { geo in
                ZStack {
                    VStack(spacing: 0) {
                        TabView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        HStack(spacing: 0) {
                            TabButton(tab: .Home, currentTab: $viewModel.currentTab)
                            TabButton(tab: .Calender, currentTab: $viewModel.currentTab)
                            TabButton(tab: .Game, currentTab: $viewModel.currentTab)
                            TabButton(tab: .Setting, currentTab: $viewModel.currentTab)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, geo.safeAreaInsets.bottom)
                        .padding(.top, 12)
                        .background(.white)
                        .edgesIgnoringSafeArea(.bottom)
                        .shadow(color: Color(red: 242/255, green: 242/255, blue: 229/255), radius: 17, x: 0, y: -1)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    
                    if calendarViewModel.showMonthSelectModalView {
                        MonthSelectModalView(viewModel: calendarViewModel, showModalView: $calendarViewModel.showMonthSelectModalView)
                    }
                    
                    if viewModel.showStartAlert {
                        CustomStartAlert(showAlert: $viewModel.showStartAlert)
                    }
                    
                    if settingViewModel.visiblePwSettingView && (viewModel.currentTab == .Home || viewModel.currentTab == .Calender) {
                        PasswordInputView(
                            password: $settingViewModel.appPassWord,
                            title: $settingViewModel.inputViewTitle,
                            visibleWarningMessage: $settingViewModel.visibleWarningMessage,
                            appendAction: { number in
                                settingViewModel.addPassWord(number: number)
                            },
                            removeAction: {
                                settingViewModel.removePassWord()
                            }
                        )
                        .frame(width: geo.size.width, height: geo.size.height)
                        .background(UIColor.CommonBackground.background.color)
                        .transition(.opacity)
                        .zIndex(999) // 다른 뷰보다 위에 오도록 설정
                    }
                }
                
                NavigationLink("", isActive: $calendarViewModel.showDiaryView) {
                    LazyView(
                        DiaryView(viewModel: calendarViewModel) // TODO: 등록 진입인지 수정 진입인진 이때 결정
                            .background(Color.white)
                            .navigationBarHidden(true)
                    )
                }
                
                NavigationLink("", isActive: $homeViewModel.showGoldInfoView) {
                    LazyView(
                        GoldInfoView(viewModel: homeViewModel)
                            .background(Color.white)
                            .navigationBarHidden(true)
                    )
                }
            }
            .ignoresSafeArea(.keyboard)
            .background(UIColor.CommonBackground.background.color)
            .onAppearWithCount { count in
                if count == 1 {
                    viewModel.registerNotification()
                }
            }
        })
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if settingViewModel.lockEnable && (viewModel.currentTab == .Home || viewModel.currentTab == .Calender) && !settingViewModel.visiblePwSettingView {
                    settingViewModel.startPasswordValidation()
                }
            }
        }
        .navigationBarHidden(true)
        
    }
}

/// ViewBuilder
extension MainTabView {
    @ViewBuilder
    func TabView() -> some View {
        switch viewModel.currentTab {
        case .Home:
            HomeView(viewModel: homeViewModel)
        case .Calender:
            CalendarView(viewModel: calendarViewModel)
        case .Game:
            GameView()
        case .Setting:
            SettingView(settingViewModel: settingViewModel, mainViewModel: viewModel)
        }
    }
}

struct TabButton: View {
    let tab: Tab
    @Binding var currentTab: Tab
    
    @State private var isPressed = false
    
    private var iconName: String { return tab.iconName + (currentTab == tab ? "_B" : "") }
    
    var body: some View {
        Button(action: {
            withAnimation {
                currentTab = tab
            }
        }, label: {
            VStack(spacing: 6) {
                Image(iconName).scaleEffect(isPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isPressed)
                
                Text(tab.title)
                    .font(size: 14)
                    .foregroundColor(currentTab == tab ? .black : UIColor.Gray.gray300.color)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
        })
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    var viewModel: MainViewModel = MainViewModel()
    return MainTabView(viewModel: viewModel)
}
