//
//  LockSettingView.swift
//  EOD
//
//  Created by JooYoung Kim on 4/5/25.
//

import SwiftUI

struct LockSettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                NavigationBarView(title: "앱 잠금 설정", dismissAction: {
                    if viewModel.visiblePwSettingView || viewModel.changePwSettingView {
                        viewModel.visiblePwSettingView = false
                        viewModel.changePwSettingView = false
                        viewModel.resetPasswordInput()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                
                Spacer()
                
                if viewModel.visiblePwSettingView || viewModel.changePwSettingView {
                    PasswordInputView(password: $viewModel.appPassWord,
                                      title: $viewModel.inputViewTitle,
                                      visibleWarningMessage: $viewModel.visibleWarningMessage,
                                      appendAction: { number in
                        viewModel.addPassWord(number: number)
                    }, removeAction: {
                        viewModel.removePassWord()
                    })
                } else {
                    VStack(alignment: .leading) {
                        Text("비밀번호 설정")
                            .font(type: .omyu, size: 22)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 0) {
                            Text("앱 잠그기")
                                .font(type: .omyu, size: 18)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Toggle("", isOn: $viewModel.lockEnable)
                                .toggleStyle(SwitchToggleStyle(tint: UIColor.Yellow.yellow500.color))
                                .labelsHidden()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.white)
                        .cornerRadius(10)
                        
                        Spacer().frame(height: 8)
                        
                        if viewModel.lockEnable {
                            Button {
                                viewModel.startPasswordChange()
                            } label: {
                                HStack {
                                    Text("비밀번호 변경")
                                        .font(type: .omyu, size: 18)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image("btn_right_arrow")
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(.white)
                                .cornerRadius(10)
                            }
                            
                            Spacer().frame(height: 8)
                        }
                        
                        HStack(spacing: 5) {
                            Image("icon_warning")
                                .padding(.top, 10)
                                .padding(.bottom, 27)
                                
                            Text("비밀번호를 잊어버리면 앱을 초기화해야 해요.\n데이터를 되찾을 수 없으니 신중히 설정하세요.")
                                .font(type: .omyu, size: 16)
                                .foregroundColor(.black)
                                .padding(.top, 16)
                                .padding(.bottom, 16)
                                .lineSpacing(5)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
            }
            .background(UIColor.CommonBackground.background.color)
            
            ToastView(toastManager: viewModel.toastManager)
        }
    }
}

#Preview {
    var viewModel = SettingViewModel()
    viewModel.appPassWord = []
    
    return LockSettingView(viewModel: viewModel)
}
