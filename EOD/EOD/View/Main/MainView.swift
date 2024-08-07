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
                } else { // 로그인 상태가 아닐경우
                    IntroView(viewModel: viewModel)
                }
            }
            
        }.ignoresSafeArea(.keyboard)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
