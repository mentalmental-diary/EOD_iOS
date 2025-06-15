//
//  SettingView.swift
//  EOD
//
//  Created by JooYoung Kim on 7/27/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var settingViewModel: SettingViewModel
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                
                Text("설정")
                    .font(type: .omyu, size: 22)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.clear)
            
            Spacer().frame(height: 35)
            
            accountSettingView()
            
            Spacer().frame(height: 22)
            
            alarmSettingView()
            
            Spacer().frame(height: 22)
            
            securitySettingView()
            
            Spacer().frame(height: 22)
            
            etcSettingView()
            
            Spacer()
        }
        .padding(.top, 15)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UIColor.CommonBackground.background.color)
        
    }
}

extension SettingView {
    private func accountSettingView() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("계정 설정")
                .font(type: .omyu, size: 22)
                .foregroundColor(.black)
            
            NavigationLink(destination:
                            UserInfoSetView(viewModel: mainViewModel)
                .onAppear(perform: {
                    mainViewModel.getNickname()
                })
                .background(Color.white)
                .navigationBarHidden(true)
            ) {
                HStack {
                    Text("닉네임 변경")
                        .font(type: .omyu, size: 18)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image("btn_right_arrow")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.white)
                .cornerRadius(10)
            }
        }
    }
    
    private func alarmSettingView() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("알림 설정")
                .font(type: .omyu, size: 22)
                .foregroundColor(.black)
            
            NavigationLink(destination:
                            AlarmSettingView(viewModel: settingViewModel)
                    .background(Color.white)
                    .navigationBarHidden(true)
            ) {
                HStack {
                    Text("알림 설정")
                        .font(type: .omyu, size: 18)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image("btn_right_arrow")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.white)
                .cornerRadius(10)
            }
        }
    }
    
    private func securitySettingView() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("보안 및 개인 정보 보호")
                .font(type: .omyu, size: 22)
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                NavigationLink(destination:
                                LockSettingView(viewModel: settingViewModel)
                        .background(Color.white)
                        .navigationBarHidden(true)
                ) {
                    HStack {
                        Text("앱 잠금 설정")
                            .font(type: .omyu, size: 18)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image("btn_right_arrow")
                    }
                    .padding(.vertical, 12)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Text("회원 탈퇴")
                            .font(type: .omyu, size: 18)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image("btn_right_arrow")
                    }
                    .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(10)
        }
    }
    
    private func etcSettingView() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("기타")
                .font(type: .omyu, size: 22)
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                HStack {
                    Text("앱 버전")
                        .font(type: .omyu, size: 18)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("v1.0.0") // TODO: 앱 버전 받는 방법이랑 어떻게 노출시킬지 확인해보기
                        .font(type: .omyu, size: 18)
                        .foregroundColor(UIColor.Gray.gray500.color)
                }
                .padding(.vertical, 12)
                
                
                Button {
                    
                } label: {
                    HStack {
                        Text("개인정보 보호 정책")
                            .font(type: .omyu, size: 18)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.vertical, 18.5)
                }
                
                Button {
                    mainViewModel.logoutAction()
                } label: {
                    HStack {
                        Text("로그아웃")
                            .font(type: .omyu, size: 18)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image("btn_right_arrow")
                    }
                    .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    SettingView(settingViewModel: SettingViewModel(), mainViewModel: MainViewModel())
}
