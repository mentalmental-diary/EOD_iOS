//
//  SignUpView.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: MainViewModel
    
    @State var inputEmail: String = ""
    @State var inputPassword: String = ""
    @State var validPassword: String = ""
    @State var privacyKey: String = ""
    @State var passwordMasking: Bool = true
    @State var validPasswordMasking: Bool = true
    @State var isShowAlert: Bool = false
    @State var visibleLoginView: Bool = false
    
    var body: some View {
        NavigationView(content: {
            GeometryReader { proxy in
                ZStack {
                    VStack(alignment: .leading) {
                        NavigationBarView(title: "가입하기", dismissAction: dismissAction)
                        
                        Spacer().frame(height: 56)
                        
                        inputView()
                        
                        Spacer()
                        
                        bottomView()
                    }
                    .padding(.bottom, proxy.safeAreaInsets.bottom)
                    .edgesIgnoringSafeArea(.bottom)
                    .background(UIColor.CommonBackground.background.color)
                    
                    if isShowAlert {
                        Alert(showAlert: $isShowAlert, title: "회원 가입을 그만 둘까요?", message: "그만 두기를 누르면 작성한 내용이 저장되지 않아요", accept: "그만 두기", acceptAction: {
                            presentationMode.wrappedValue.dismiss()
                            viewModel.presentSignUpView = false
                        }, cancel: "취소")
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        })
        .onAppear(perform: {
            viewModel.presentSignUpView = true
        })
    }
}

// ViewBuilder
extension SignUpView {
    @ViewBuilder func inputView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("시작해볼까요?")
                .font(size: 22)
                .foregroundColor(Color.black)
                .padding(.horizontal, 2)
                .background(Rectangle()
                    .foregroundColor(UIColor.Yellow.yellow200.color)
                    .frame(height: 8), alignment: .bottom)
            
            Spacer().frame(height: 40)
            
            Text("아이디")
                .font(size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 20)
            
            inputEmailView()
            
            Spacer().frame(height: 16)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(inputEmail.isEmpty ? UIColor.Gray.gray300.color : Color.black)
            
            Spacer().frame(height: 25)
            
            validEmailView()
            
            Spacer().frame(height: viewModel.confirmEmail ? 11 : 64)
            
            if viewModel.confirmEmail {
                HStack {
                    Image("icon_validCheck")
                    
                    Text("인증이 완료되었어요.")
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer().frame(height: viewModel.confirmEmail ? 44 : 0)
            
            Text("비밀번호")
                .font(size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 25)
            
            inputPasswordView()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func inputEmailView() -> some View {
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
    }
    
    @ViewBuilder func validEmailView() -> some View {
        HStack(spacing: 12) {
            VStack {
                ZStack(alignment: .leading) {
                    if privacyKey.isEmpty {
                        Text("인증 키 입력")
                            .font(.system(size: 16))
                            .foregroundColor(UIColor.Gray.gray300.color)
                            .frame(height: 16)
                    }
                    
                    TextField("", text: $privacyKey)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                    
                }
                .padding(.bottom, 1)
                
                Divider()
                    .frame(minHeight: 1.0)
                    .overlay(privacyKey.isEmpty ? UIColor.Gray.gray300.color : Color.black)
            }
            
            Button(action: {
                // TODO: 이메일 인증 API확인
            }, label: {
                Text("인증 키 발송")
                    .font(size: 14)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 28)
                    .background(Color.black)
                    .cornerRadius(6.0)
                    .contentShape(Rectangle()) // 전체 영역이 터치 가능하도록 설정
            })
        }
    }
    
    @ViewBuilder func inputPasswordView() -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                if inputPassword.isEmpty {
                    Text("8자 이상, 숫자 및 영어 소문자 필수")
                        .font(.system(size: 16))
                        .foregroundColor(UIColor.Gray.gray300.color)
                        .frame(height: 16)
                }
                
                if passwordMasking {
                    SecureField("", text: $inputPassword)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                } else {
                    TextField("", text: $inputPassword)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                }
                
                Button {
                    self.passwordMasking.toggle()
                } label: {
                    Image(passwordMasking ? "icon_eyes_off" : "icon_eyes_on").frame(width: 24, height: 24, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .padding(.bottom, 1)
            
            Spacer().frame(height: 8)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(inputPassword.isEmpty ? UIColor.Gray.gray300.color : Color.black)
            
            Spacer().frame(height: 26)
            
            ZStack(alignment: .leading) {
                if validPassword.isEmpty {
                    Text("비밀번호 확인")
                        .font(.system(size: 16))
                        .foregroundColor(UIColor.Gray.gray300.color)
                        .frame(height: 16)
                }
                
                if validPasswordMasking {
                    SecureField("", text: $validPassword)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                } else {
                    TextField("", text: $validPassword)
                        .background(Color.clear)
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                        .frame(height: 16)
                }
                
                Button {
                    self.validPasswordMasking.toggle()
                } label: {
                    Image(validPasswordMasking ? "icon_eyes_off" : "icon_eyes_on").frame(width: 24, height: 24, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .padding(.bottom, 1)
            
            Spacer().frame(height: 8)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(validPassword.isEmpty ? UIColor.Gray.gray300.color : Color.black)
        }
    }
    
    @ViewBuilder func bottomView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 1) {
                Button(action: {
                    viewModel.confirmTerms.toggle()
                }, label: {
                    Image(viewModel.confirmTerms ? "btnConfirmOn" : "btnConfirmOff")
                })
                
                Text("약관 동의") // TODO: 향후 문구 변경 및 약관 동의창 넘기는 것 진행 필요
                    .foregroundColor(.black)
            }
            
            Spacer().frame(height: 12)
            
            Button(action: {
                viewModel.signUpAction(email: inputEmail, password: inputPassword) // TODO: 회원가입 액션 생성
//                if availableLoginButton {
//                    viewModel.signUpAction(email: inputEmail, password: inputPassword) // TODO: 회원가입 액션 생성
//                }
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
            
            Spacer().frame(height: 20)
            
            HStack {
                Text("이미 계정이 있나요?")
                    .font(size: 20)
                    .foregroundColor(UIColor.Gray.gray500.color)
                
                Button(action: {
                    if viewModel.presentLoginView {
                        dismissAction()
                    } else {
                        visibleLoginView = true
                    }
                }, label: {
                    Text("로그인")
                        .font(size: 20)
                        .underline(true)
                        .foregroundColor(UIColor.Gray.gray900.color)
                })
                .background(
                    NavigationLink(destination: LazyView(
                        LoginView(viewModel: viewModel)
                            .navigationBarHidden(true)
                    ), isActive: $visibleLoginView) {
                        EmptyView()
                    }
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

extension SignUpView {
    func dismissAction() {
        if emptyInfo {
            viewModel.presentSignUpView = false
            presentationMode.wrappedValue.dismiss()
        } else {
            isShowAlert = true
        }
    }
}

/// Var
extension SignUpView {
    private var availableLoginButton: Bool { return !inputEmail.isEmpty && !inputPassword.isEmpty && viewModel.confirmEmail && inputPassword == validPassword } // 모든 정보가 입력되었고 비밀번호 동일하다면 진행
    
    private var emptyInfo: Bool { return inputEmail.isEmpty && inputPassword.isEmpty && validPassword.isEmpty && privacyKey.isEmpty }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: MainViewModel())
    }
}
