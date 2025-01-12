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
    
    @State var initScreen: Bool = true // 초기 웰컴 화면
    
    var body: some View {
        NavigationView(content: {
            GeometryReader { geometry in
                if initScreen {
                    tutorialView(geometry: geometry)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    onBoardingView(geometry: geometry)
                }
            }
        })
    }
}

/// ViewBuilder
extension IntroView {
    @ViewBuilder func tutorialView(geometry: GeometryProxy) -> some View {
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
                    .font(size: 32) // TODO: 나중에 해당 폰트 확인
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
                                
                                debugLog("로그인 토큰 정보: \(userIdentifier)")
                                
                                // 서버로 사용자 정보 전달
    //                            Task {
    //                                await handleServerAuthentication(userIdentifier: userIdentifier, email: email, firstName: firstName, lastName: lastName)
    //                            }
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
