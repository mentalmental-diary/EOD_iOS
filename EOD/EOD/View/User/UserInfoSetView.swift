//
//  UserInfoSetView.swift
//  EOD
//
//  Created by JooYoung Kim on 12/29/24.
//

import SwiftUI
import SafariServices

struct UserInfoSetView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var keyboard = KeyboardObserver()
    @State private var shouldShowKeyboardToolbar = false
    
    @FocusState private var nicknameFieldFocused: Bool
    @State private var isShowingSafari = false
    
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
                    viewModel.confirmTerms.toggle()
                }, label: {
                    Image(viewModel.confirmTerms ? "btnConfirmOn" : "btnConfirmOff")
                })
                
                Spacer().frame(width: 4)
                
                HStack(spacing: 0) {
                    Text("(필수) ")
                        .font(type: .pretendard, weight: .bold, size: 13)
                        .foregroundColor(.black)
                    
                    Button {
                        isShowingSafari = true
                    } label: {
                        Text("이용약관")
                            .font(type: .pretendard, weight: .medium, size: 13)
                            .underline()
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $isShowingSafari) {
                        if let url = URL(string: viewModel.termsURL) {
                            SafariView(url: url)
                        }
                    }
                    
                    Text(" 및 ")
                        .font(type: .pretendard, weight: .medium, size: 13)
                        .foregroundColor(.black)
                    
                    Button {
                        isShowingSafari = true
                    } label: {
                        Text("개인정보 수집 및 이용")
                            .font(type: .pretendard, weight: .medium, size: 13)
                            .underline()
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $isShowingSafari) {
                        if let url = URL(string: viewModel.personalInfomationURL) {
                            SafariView(url: url)
                        }
                    }
                    
                    Text("에 동의합니다.")
                        .font(type: .pretendard, weight: .medium, size: 13)
                        .foregroundColor(.black)

                }
                .frame(height: 19)
            }
            
            Spacer().frame(height: 12)
            
            Button(action: {
                if availableStartButton {
                    viewModel.setNickname()
                }
            }, label: {
                Text("시작하기")
                    .font(size: 20)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(availableStartButton ? Color.black : Color(red: 211/255, green: 210/255, blue: 207/255))
                    .cornerRadius(8.0)
                    .contentShape(Rectangle()) // 전체 영역이 터치 가능하도록 설정
            })
        }
    }
}

extension UserInfoSetView {
    private var availableStartButton: Bool { return viewModel.confirmTerms && viewModel.inputNickname.count > 0 }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Nothing to update
    }
}

struct UserInfoSetView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoSetView(viewModel: MainViewModel())
    }
}
