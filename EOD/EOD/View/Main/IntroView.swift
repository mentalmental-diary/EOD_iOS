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
        NavigationView(content: {
            GeometryReader { geometry in
                if initScreen {
                    welcomeView(geometry: geometry)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    tutorialView(geometry: geometry)
                }
            }
        })
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
                    .foregroundColor(Color.black)
                    .tag(0)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // 페이지 2
                Text("튜토리얼 화면 2")
                    .foregroundColor(Color.black)
                    .tag(1)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // 페이지 3
                Text("튜토리얼 화면 3")
                    .foregroundColor(Color.black)
                    .tag(2)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            PageControlView(currentPage: $currentPage, pages: 3)
            
            HStack(spacing: 11) {
                Divider()
                    .frame(maxWidth: .infinity, maxHeight: 1.0)
                    .overlay(UIColor.Gray.gray100.color)
                
                Text("간편 로그인")
                    .font(size: 16)
                    .foregroundColor(UIColor.Gray.gray500.color)
                
                Divider()
                    .frame(maxWidth: .infinity, maxHeight: 1.0)
                    .overlay(UIColor.Gray.gray100.color)
            }
            .padding(.horizontal, 22)
            
            Spacer().frame(height: 15)
            
            HStack {
                Image("icon_basic") // TODO: 임시 이미지 사용
                Image("icon_basic") // 임시 이미지 사용
                Image("icon_basic") // 임시 이미지 사용
            }
            .frame(maxWidth: .infinity)
            
            Spacer().frame(height: 20)
            
            buttonView()
            
            Spacer()
        }
        .padding(.bottom, 34 + geometry.safeAreaInsets.bottom)
        .background(UIColor.CommonBackground.background.color)
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

/// ViewBuilder
extension IntroView {
    @ViewBuilder func buttonView() -> some View {
        VStack(spacing: 12) {
            NavigationLink(destination: {
                LazyView(
                    LoginView(viewModel: viewModel).navigationBarHidden(true)
                )
            }, label: {
                Text("이메일로 로그인")
                    .font(size: 20)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(8.0)
            })
            
            NavigationLink(destination: {
                LazyView(
                    SignUpView(viewModel: viewModel).navigationBarHidden(true)
                )
            }, label: {
                Text("회원가입")
                    .font(size: 20)
                    .foregroundColor(Color.black)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1) // 검정색 테두리
                    )
            })
        }
        .padding(.horizontal, 20)
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: MainViewModel())
    }
}
