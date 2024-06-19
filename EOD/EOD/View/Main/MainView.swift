//
//  MainView.swift
//  EOD
//
//  Created by Joo Young Kim on 2023/09/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            if viewModel.isLogin { // 로그인 상태일경우
                MainTabView(viewModel: viewModel)
            } else { // 로그인 상태가 아닐경우
                IntroView(viewModel: viewModel)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
