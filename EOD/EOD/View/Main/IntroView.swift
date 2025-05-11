//
//  IntroView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import AuthenticationServices
import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var currentPage: Int = 0
    @State private var showSkipButton: Bool = true // Skip 버튼 표시 여부
    @State private var showHighlightedButton: Bool = false // 하단 버튼 강조 여부
    
    var body: some View {
        NavigationView(content: {
            GeometryReader { geometry in
                if viewModel.initScreen {
                    tutorialView(geometry: geometry)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    onBoardingView(geometry: geometry)
                }
                
            }
            .fullScreenCover(isPresented: $viewModel.showUserInfoSetView) {
                UserInfoSetView(viewModel: viewModel)
                    .background(UIColor.CommonBackground.background.color)
                    .navigationBarHidden(true)
            }
        })
    }
}

/// ViewBuilder
extension IntroView {
    @ViewBuilder func tutorialView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if showSkipButton {
                Button {
                    viewModel.initScreen = false
                } label: {
                    Text("Skip")
                        .font(size: 22)
                        .foregroundColor(UIColor.Gray.gray800.color)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 20)
                .transition(.opacity) // 사라질 때 애니메이션 효과 적용
                .animation(.easeInOut(duration: 0.3), value: currentPage) // 애니메이션 적용
            }
            
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.onboardingItems.enumerated()), id: \.element.id) { index, item in
                    onBoadingDetailView(item: item)
                        .tag(index) // 명확하게 index 사용
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: currentPage) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // TabView 이동 후 실행
                    withAnimation {
                        showSkipButton = (newValue < 2) // 2가 되면 Skip 버튼 숨기기
                        showHighlightedButton = (newValue == 2) // 2가 되면 하단 버튼 강조
                    }
                }
            }
            
            Spacer().frame(height: 36)
            
            PageControlView(currentPage: $currentPage, pages: 3)
            
            Spacer().frame(height: 84)
            
            Button(action: {
                withAnimation {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        viewModel.initScreen = false
                    }
                }
            }, label: {
                Text(showHighlightedButton ? "시작하기" : "다음")
                    .font(size: 20)
                    .foregroundColor(Color.black)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(showHighlightedButton ? UIColor.Yellow.yellow500.color : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(showHighlightedButton ? .clear : .black, lineWidth: 1)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    )
            })
            .animation(.easeInOut(duration: 0.3), value: currentPage) // currentPage 변화에 애니메이션 적용
            .frame(maxWidth: .infinity)
            .cornerRadius(8.0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 34 + geometry.safeAreaInsets.bottom)
        .background(UIColor.CommonBackground.background.color)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder func onBoardingView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0.0) {
            
            VStack(spacing: 0) {
                Button {
                    viewModel.testLogin()
                } label: {
                    Text("테스트 로그인")
                }

                Spacer()
                
                Image("icon_onBoarding")
                
                Spacer().frame(height: 37)
                
                Text("노른자의 하루")
                    .font(type: .cafe24Ssurround, size: 32)
                    .foregroundColor(UIColor.Yellow.yellow500.color)
                    .lineSpacing(6)
                
                Spacer().frame(height: 20)
                
                Text("노른자와 함께 일상을 꾸며볼까요?")
                    .font(size: 22)
                    .foregroundColor(UIColor.Gray.gray500.color)
                    .lineSpacing(2)
            }
            
            Spacer().frame(height: 140)
            
            socialLoginView()
            
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
    
    private func socialLoginView() -> some View { // TODO: 나중에 소셜로그인 추가되면 그때 작업하기
        VStack(spacing: 16) {
            Button {
                viewModel.kakaoLoginAction()
            } label: {
                HStack(spacing: 9) {
                    Spacer()
                    
                    Image("kakao_logo")
                    
                    Text("카카오로 로그인")
                        .font(size: 20)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .background(Color(red: 254/255, green: 229/255, blue: 0))
                .cornerRadius(8)
            }

            Button {
#if !PREVIEW
                LoginManager.shared.login() // TODO: 네이밍 변경
                #endif
            } label: {
                HStack(spacing: 9) {
                    Spacer()
                    
                    Image("naver_logo")
                    
                    Text("네이버로 로그인")
                        .font(size: 20)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .background(Color(red: 3/255, green: 199/255, blue: 90/255))
                .cornerRadius(8)
            }

            HStack(spacing: 9) {
                Spacer()
                
                Image(systemName: "applelogo")
                    .foregroundColor(.white)
                
                Text("Apple로 로그인")
                    .font(size: 20)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .background(.black)
            .cornerRadius(8)
            .overlay {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                                // 애플 ID에서 사용자 정보 가져오기
                                let userIdentifier = appleIDCredential.user
                                let email = appleIDCredential.email
                                let fullName = appleIDCredential.fullName
                                let firstName = fullName?.givenName ?? ""
                                let lastName = fullName?.familyName ?? ""
                                
                                if let token = appleIDCredential.authorizationCode,
                                   let identityTokenString = String(data: token, encoding: .utf8) {
                                    
                                    debugLog("로그인 토큰값 : \(token)")
                                    viewModel.appleLoginAction(token: identityTokenString)
                                }
                            }
                        case .failure(let error):
                            errorLog("Error: \(error.localizedDescription)")
                        }
                    }
                )
                .blendMode(.overlay)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: MainViewModel())
    }
}
