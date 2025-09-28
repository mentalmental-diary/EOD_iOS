//
//  MainView.swift
//  EOD
//
//  Created by Joo Young Kim on 2023/09/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel = MainViewModel()
    @State var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                if isLoading {
                    SplashView()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                withAnimation {
                                    self.isLoading = false
                                }
                            })
                        }
                } else {
                    if viewModel.isLogin { // 로그인 상태일경우
                        MainTabView(viewModel: viewModel)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else { // 로그인 상태가 아닐경우
                        IntroView(viewModel: viewModel)
                    }
                }
                
            }.ignoresSafeArea(.keyboard)
            
            // 앱 전체에서 최상단에 토스트 표시
            VStack {
                ToastView(toastManager: viewModel.toastManager)
                Spacer()
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
