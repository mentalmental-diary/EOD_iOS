//
//  LoginView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: MainViewModel
    
    @State var inputEmail: String = ""
    @State var inputPassWord: String = ""
    @State var isMasking: Bool = true // 마스킹 처리 여부
    @State var visibleSignUpView: Bool = false
    
    var body: some View {
        NavigationView(content: {
            GeometryReader { proxy in
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        NavigationBarView(title: "로그인", dismissAction: dismissAction)
                        
                        Spacer().frame(height: 56)
                        
                        inputView()
                        
                        Spacer().frame(height: 40)
                        
                        forgetPasswordView()
                        
                        Spacer()
                        
                        bottomView()
                    }
                    .padding(.bottom, proxy.safeAreaInsets.bottom)
                    .edgesIgnoringSafeArea(.bottom)
                    .background(UIColor.CommonBackground.background.color)
                    
                }
            }
            .ignoresSafeArea(.keyboard)
        })
        .onAppear(perform: {
            viewModel.presentLoginView = true
        })
    }
}

extension LoginView {
    @ViewBuilder func inputView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("노른자 만나러 갈까요?")
                .font(size: 22)
                .foregroundColor(Color.black)
                .padding(.horizontal, 2)
                .background(Rectangle()
                    .foregroundColor(UIColor.Yellow.yellow200.color)
                    .frame(height: 8), alignment: .bottom)
            
            Spacer().frame(height: 40)
            
            Text("아이디") // TODO: 다른 폰트 추가
                .font(size: 20)
                .foregroundColor(Color.black)
            
            Spacer().frame(height: 20)
            
            ZStack(alignment: .leading) {
                if inputEmail.isEmpty {
                    Text("이메일 주소")
                        .font(.system(size: 16))
                        .foregroundColor(UIColor.Gray.gray300.color)
                        .frame(height: 16)
                }
                
                TextField("", text: $inputEmail)
                    .background(Color.clear)
                    .font(.system(size: 16))
                    .foregroundColor(Color.black)
                    .frame(height: 16)
                
            }
            .padding(.bottom, 1)
            
            Spacer().frame(height: 16)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(inputEmail.isEmpty ? UIColor.Gray.gray300.color : Color.black)
            
            Spacer().frame(height: 40)
            
            Text("비밀번호")
                .font(size: 20)
                .foregroundColor(Color.black)
            
            Spacer().frame(height: 25)
            
            ZStack(alignment: .leading) {
                if inputPassWord.isEmpty {
                    Text("8자 이상, 숫자 및 영어 소문자 필수")
                        .font(.system(size: 16))
                        .foregroundColor(UIColor.Gray.gray300.color)
                        .frame(height: 16)
                }
                
                if isMasking {
                    SecureField("", text: $inputPassWord)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                } else {
                    TextField("", text: $inputPassWord)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                }
                
                Button {
                    self.isMasking.toggle()
                } label: {
                    Image(isMasking ? "icon_eyes_off" : "icon_eyes_on").frame(width: 24, height: 24, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .padding(.bottom, 1)
            
            Spacer().frame(height: 8)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(inputPassWord.isEmpty ? UIColor.Gray.gray300.color : Color.black)
            
            
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func forgetPasswordView() -> some View {
        HStack(spacing: 4) {
            Text("비밀번호를 잊었나요?")
                .font(size: 16)
                .foregroundColor(UIColor.Gray.gray500.color)
            
            NavigationLink {
                // TODO: 비밀번호 찾기는... 웹페이지 하나 만드는게 나으려나
            } label: {
                Text("비밀번호 찾기")
                    .font(size: 16)
                    .foregroundColor(UIColor.Gray.gray500.color)
                    .underline(true)
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func bottomView() -> some View {
        VStack(spacing: 20) {
            Button(action: {
                if availableLoginButton {
                    viewModel.loginAction() // TODO: 로그인 액션 생성
                }
            }, label: {
                Text("시작하기")
                    .font(size: 20)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(availableLoginButton ? Color.black : Color(red: 211/255, green: 210/255, blue: 207/255))
                    .cornerRadius(8.0)
                    .contentShape(Rectangle()) // 전체 영역이 터치 가능하도록 설정
            })
            
            HStack {
                Text("계정이 없으신가요?")
                    .font(size: 20)
                    .foregroundColor(UIColor.Gray.gray500.color)
                
                Button(action: {
                    if viewModel.presentSignUpView {
                        dismissAction()
                    } else {
                        visibleSignUpView = true
                    }
                }, label: {
                    Text("가입하기")
                        .font(size: 20)
                        .underline(true)
                        .foregroundColor(UIColor.Gray.gray900.color)
                })
                .background(
                    NavigationLink(destination: LazyView(
                        SignUpView(viewModel: viewModel)
                            .navigationBarHidden(true)
                    ), isActive: $visibleSignUpView) {
                        EmptyView()
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        
    }
}

/// Var
extension LoginView {
    private var availableLoginButton: Bool { return !inputEmail.isEmpty && !inputPassWord.isEmpty }
}

extension LoginView {
    func dismissAction() {
        viewModel.presentLoginView = false
        presentationMode.wrappedValue.dismiss()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: MainViewModel())
    }
}
