//
//  UserInfoSetView.swift
//  EOD
//
//  Created by JooYoung Kim on 12/29/24.
//

import SwiftUI

struct UserInfoSetView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State var inputNickname: String = ""
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        Text("닉네임 설정")
                            .font(size: 28)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    Spacer().frame(height: 56)
                    
                    Text("노른자의 하루에서 사용할")
                        .font(size: 22)
                        .foregroundColor(.black)
                        .background(
                            GeometryReader { geometry in
                                UIColor.Yellow.yellow200.color
                                    .frame(width: geometry.size.width, height: 8)
                                    .offset(x: 0, y: geometry.size.height - 8)
                            }
                        )
                    
                    Text("닉네임을 알려주세요!")
                        .font(size: 22)
                        .foregroundColor(.black)
                        .background(
                            GeometryReader { geometry in
                                UIColor.Yellow.yellow200.color
                                    .frame(width: geometry.size.width, height: 8)
                                    .offset(x: 0, y: geometry.size.height - 8)
                            }
                        )
                    
                    Spacer().frame(height: 137)
                    
                    nicknameView()
                    
                    Spacer().frame(height: 250)
                    
                    bottonView()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)
                .toast(message: viewModel.toastMessage, visibleIcon: true, isShowing: $viewModel.isToast)
            }
            .ignoresSafeArea(.keyboard)
        }
        
    }
}

extension UserInfoSetView {
    private func nicknameView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .font(size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 20)
            
            ZStack(alignment: .leading) {
                if inputNickname.isEmpty {
                    Text("닉네임을 입력해주세요.")
                        .font(.system(size: 16))
                        .foregroundColor(UIColor.Gray.gray500.color)
                        .frame(height: 16)
                }
                
                TextField("", text: $inputNickname)
                    .background(Color.clear)
                    .font(.system(size: 16))
                    .foregroundColor(Color.black)
                    .frame(height: 16)
                
            }
            .padding(.bottom, 1)
            
            Spacer().frame(height: 16)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(inputNickname.isEmpty ? UIColor.Gray.gray500.color : Color.black)
            
            Spacer().frame(height: 14)
            
            Text("닉네임은 설정 > 시스템 설정 > 프로필 관리에서 변경할 수 있어요.")
                .font(size: 14)
                .foregroundColor(UIColor.Gray.gray700.color)
        }
    }
    
    private func bottonView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.confirmTerms.toggle() // TODO: 약관 관련 값 변경
                }, label: {
                    Image(viewModel.confirmTerms ? "btnConfirmOn" : "btnConfirmOff")
                })
                
                Spacer().frame(width: 4)
                
                HStack(spacing: 0) {
                    Text("(필수) ")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    
                    Button {
                        
                    } label: {
                        Text("개인 정보 처리 방침")
                            .underline()
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                    
                    Text(" 및 ")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    
                    Button {
                        
                    } label: {
                        Text("서비스 이용 약관")
                            .underline()
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                    }
                    
                    Text("에 동의합니다.")
                        .font(.system(size: 13))
                        .foregroundColor(.black)

                }
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.confirmTerms.toggle()
                }, label: {
                    Image(viewModel.confirmTerms ? "btnConfirmOn" : "btnConfirmOff")
                })
                
                Spacer().frame(width: 4)
                
                Text("(선택) 이벤트 및 광고성 알림 수신에 동의합니다.")
                    .font(.system(size: 13))
                    .foregroundColor(.black)
            }
            
            Spacer().frame(height: 22)
            
            Button(action: {
                viewModel.setNickname(nickName: inputNickname)
            }, label: {
                Text("시작하기")
                    .font(size: 20)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.confirmTerms ? Color.black : Color(red: 211/255, green: 210/255, blue: 207/255))
                    .cornerRadius(8.0)
                    .contentShape(Rectangle()) // 전체 영역이 터치 가능하도록 설정
            })
        }
    }
}

struct UserInfoSetView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoSetView(viewModel: MainViewModel())
    }
}
