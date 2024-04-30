//
//  LoginView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("로그인 화면입니다.")
            Button {
                viewModel.test()
            } label: {
                Text("네이버 로그인")
            }
            Button {
                viewModel.test()
            } label: {
                Text("카카오 로그인")
            }
            Button {
                viewModel.test()
            } label: {
                Text("애플 로그인")
            }
            Button {
                viewModel.test()
            } label: {
                Text("일반 로그인")
            }
            Button {
                viewModel.test()
            } label: {
                Text("회원가입")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: MainViewModel())
    }
}
