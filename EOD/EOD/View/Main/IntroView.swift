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
        VStack(spacing: 0) {
            if currentPage < 2 {
                Button {
                    initScreen = false
                } label: {
                    Text("Skip")
                        .font(size: 22)
                        .foregroundColor(UIColor.Gray.gray800.color)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 20)
            }
            
            TabView(selection: $currentPage) {
                ForEach(viewModel.onboardingItems) { item in
                    onBoadingDetailView(item: item)
                        .tag(viewModel.onboardingItems.firstIndex(of: item) ?? 0)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer().frame(height: 36)
            
            PageControlView(currentPage: $currentPage, pages: 3)
            
            Spacer().frame(height: 84)
            
            Button(action: {
                if currentPage < 2 {
                    currentPage += 1
                } else {
                    initScreen = false
                }
            }, label: {
                Text(currentPage < 2 ? "다음" : "시작하기")
                    .font(size: 20)
                    .foregroundColor(Color.black)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(currentPage < 2 ? .clear : UIColor.Yellow.yellow500.color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(currentPage < 2 ? .gray : .clear, lineWidth: 1)
                    )
            })
            .frame(maxWidth: .infinity)
            .cornerRadius(8.0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 34 + geometry.safeAreaInsets.bottom)
        .background(UIColor.CommonBackground.background.color)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder func tutorialView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0.0) {
            
            Text("노른자의 하루")
            
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
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func onBoadingDetailView(item: OnboardingItem) -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(item.imageName)
            
            Spacer().frame(height: 60)
            
            Text(item.title)
                .font(size: 28)
                .foregroundColor(.black)
                .lineSpacing(4)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 24)
            
            Text(item.description)
                .font(size: 18)
                .foregroundColor(Color(red: 153/255, green: 153/255, blue: 153/255))
                .lineSpacing(4)
                .multilineTextAlignment(.center)
        }
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
