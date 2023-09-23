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
        Text("메인화면 -> 로그인 유무 판단 에정 ")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
