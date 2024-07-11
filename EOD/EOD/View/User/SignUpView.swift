//
//  SignUpView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                NavigationBarView(title: "가입하기")
                
                Spacer()
                
                Text("시작해볼까요?")
                
                Text("아이디")
                
                Spacer()
            }
            .background(UIColor.CommonBackground.background.color)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
