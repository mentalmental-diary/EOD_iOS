//
//  IntroView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Text("튜토리얼 화면 및 로그인/회원가입 노출 화면")
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: MainViewModel())
    }
}
