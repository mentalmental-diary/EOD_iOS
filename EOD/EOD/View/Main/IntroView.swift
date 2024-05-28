//
//  IntroView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var currentPage: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                TabView(selection: $currentPage) {
                    // 페이지 1
                    Text("튜토리얼 화면 1")
                        .tag(0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    // 페이지 2
                    Text("튜토리얼 화면 2")
                        .tag(1)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    // 페이지 3
                    Text("튜토리얼 화면 3")
                        .tag(2)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    // 페이지 4
                    LoginView(viewModel: viewModel)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                PageControlView(currentPage: $currentPage, pages: 4)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: MainViewModel())
    }
}
