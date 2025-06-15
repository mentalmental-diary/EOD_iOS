//
//  UserInfoSetView.swift
//  EOD
//
//  Created by JooYoung Kim on 12/29/24.
//

import SwiftUI

struct UserInfoSetView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var keyboard = KeyboardObserver()
    @State private var shouldShowKeyboardToolbar = false
    
    @FocusState private var nicknameFieldFocused: Bool
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !viewModel.isLogin {
                            dismissKeyboard()
                        }
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        if viewModel.isLogin {
                            Button(action: {
                                dismissKeyboard()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }, label: {
                                Image("icon_back")
                                    .foregroundColor(Color.black)
                            })
                        }
                        
                        Spacer()
                        
                        if !viewModel.isLogin {
                            Text("닉네임 설정")
                                .font(size: 28)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        if viewModel.isLogin {
                            Button {
                                if viewModel.changeNickname {
                                    viewModel.setNickname(completion: {
                                        presentationMode.wrappedValue.dismiss()
                                    })
                                }
                            } label: {
                                HStack(spacing: 2) {
                                    Image("icon_check")
                                        .renderingMode(.template)
                                        .foregroundColor(viewModel.changeNickname ? .black : UIColor.Gray.gray500.color)
                                    
                                    Text("저장")
                                        .font(type: .omyu, size: 20)
                                        .foregroundColor(viewModel.changeNickname ? .black : UIColor.Gray.gray500.color)
                                }
                                .padding(.horizontal, 8)
                            }

                        }
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
                    
                    if !viewModel.isLogin {
                        Spacer().frame(height: 250)
                        
                        bottonView()
                    } else {
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                ToastView(toastManager: viewModel.toastManager)
                
                if !viewModel.isLogin && shouldShowKeyboardToolbar {
                    VStack {
                        Spacer()
                        
                        VStack {
                            // 상단 Border
                            Rectangle()
                                .fill(Color(red: 235/255, green: 235/255, blue: 227/255))
                                .frame(height: 1)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    nicknameFieldFocused = false
                                }) {
                                    Text("완료")
                                        .font(.custom("omyu pretty", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.top, 8)
                                        .padding(.bottom, 12)
                                }
                                .padding(.trailing, 20)
                            }
                            .frame(height: 35)
                        }
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.25), value: shouldShowKeyboardToolbar)
                        .background(Color.clear)
                    }
                    .padding(.bottom, keyboard.keyboardHeight)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .onReceive(keyboard.$keyboardHeight) { newHeight in
                if newHeight > 0 {
                    // 키보드 올라올 때는 약간 지연 후 보여주기
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation {
                            shouldShowKeyboardToolbar = true
                        }
                    }
                } else {
                    // 키보드 내려갈 땐 즉시 숨김
                    withAnimation {
                        shouldShowKeyboardToolbar = false
                    }
                }
            }
            .onAppear {
                if viewModel.isLogin {
                    viewModel.inputNickname = viewModel.currentUserNickname
                    nicknameFieldFocused = true
                }
            }
            .onDisappear {
                nicknameFieldFocused = false
            }
            .background(UIColor.CommonBackground.background.color)
            .ignoresSafeArea(.keyboard)
            
        }
        
    }
}

extension UserInfoSetView {
    private func nicknameView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .font(type: .omyu, size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 20)
            
            if viewModel.isLogin {
                TextField("닉네임을 입력해주세요.", text: $viewModel.inputNickname, axis: .vertical)
                    .font(.custom("Pretendard-Medium", size: 16))
                    .foregroundColor(.black)
                    .focused($nicknameFieldFocused)
                    .submitLabel(.continue)
                    .onChange(of: viewModel.inputNickname, { oldValue, newValue in
                        if newValue.contains("\n") {
                            viewModel.inputNickname = oldValue
                        }
                    })
            } else {
                TextField("닉네임을 입력해주세요.", text: $viewModel.inputNickname)
                    .font(.custom("Pretendard-Medium", size: 16))
                    .foregroundColor(.black)
                    .focused($nicknameFieldFocused)
                    .submitLabel(.done)
            }
            
            Spacer().frame(height: 16)
            
            Divider()
                .frame(minHeight: 1.0)
                .overlay(viewModel.inputNickname.isEmpty ? UIColor.Gray.gray500.color : Color.black)
            
            Spacer().frame(height: 14)
            
            if !viewModel.isLogin {
                Text("닉네임은 설정 > 시스템 설정 > 프로필 관리에서 변경할 수 있어요.")
                    .font(size: 14)
                    .foregroundColor(UIColor.Gray.gray700.color)
            }
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
            
            Spacer().frame(height: 6)
            
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
                viewModel.setNickname()
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
