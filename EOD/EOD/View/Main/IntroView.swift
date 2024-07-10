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
    
    @State var initScreen: Bool = true // 초기 웰컴 화면
    
    var body: some View {
        GeometryReader { geometry in
            if initScreen {
                welcomeView(geometry: geometry)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                tutorialView(geometry: geometry)
            }
        }
    }
}

/// ViewBuilder
extension IntroView {
    @ViewBuilder func welcomeView(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            
            Text("노른자의 하루")
                .font(size: 32)
                .foregroundColor(UIColor.Yellow.yellow500.color)
                .frame(maxWidth: .infinity)
            
            Image("welcome")
            
            Spacer()
            
            Text("노른자의 세계에 오신 걸 환영해요!")
                .font(size: 22)
            
            Button(action: {
                initScreen = false
            }, label: {
                Text("시작하기")
                    .font(size: 20)
                    .foregroundColor(Color.black)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(UIColor.Yellow.yellow500.color)
            })
            .frame(maxWidth: .infinity)
            .cornerRadius(8.0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 34 + geometry.safeAreaInsets.bottom)
        .background(UIColor.CommonBackground.background.color)
        .edgesIgnoringSafeArea([.top, .bottom])
    }
    
    @ViewBuilder func tutorialView(geometry: GeometryProxy) -> some View {
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
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            PageControlView(currentPage: $currentPage, pages: 4)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
        }
        .background(UIColor.CommonBackground.background.color)
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: MainViewModel())
    }
}
