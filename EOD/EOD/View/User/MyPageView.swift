//
//  MyPageView.swift
//  EOD
//
//  Created by JooYoung Kim on 7/27/24.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Button(action: {
            viewModel.logoutAction()
        }, label: {
            Text("로그아웃")
        })
    }
}

#Preview {
    MyPageView(viewModel: MainViewModel())
}
