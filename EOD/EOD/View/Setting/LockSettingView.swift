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
                    if viewModel.visiblePwSettingView {
                        viewModel.visiblePwSettingView = false
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                
                Spacer()
                
                if viewModel.visiblePwSettingView {
                    passwordSettingView()
                } else {
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
                    
                    if viewModel.lockEnable {
                        
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            ToastView(toastManager: viewModel.toastManager)
        }
    }
}

extension LockSettingView {
    private func passwordSettingView() -> some View {
        VStack {
            Text("비밀번호를 입력해주세요!")
                .font(type: .omyu, size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 24)
            
            inputPasswordView()
            
            Spacer().frame(height: 100)
            
            numberPadView()
            
            Spacer().frame(height: 64)
            
        }
        .padding(.top, 40)
    }
    
    private func inputPasswordView() -> some View {
        HStack(spacing: 7) {
            Spacer()
            
            ForEach(0..<4, id: \.self) { index in
                if index < viewModel.appPassWord.count {
                    Image("icon_pw_on")
                } else {
                    Image("icon_pw_off")
                }
            }
            
            Spacer()
        }
    }
    
    private func numberPadView() -> some View {
        let numbers = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]
        
        return VStack(spacing: 20) {
            ForEach(numbers, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.self) { num in
                        numberButton(action: {
                            viewModel.addPassWord(number: num)
                        }, number: num)
                    }
                }
            }
            
            HStack(spacing: 0) {
                Spacer().frame(width: 105)
                
                numberButton(action: {
                    viewModel.addPassWord(number: 0)
                }, number: 0)
                
                Spacer().frame(width: 34)
                
                Button {
                    viewModel.removePassWord()
                } label: {
                    Image("btn_close_B")
                        .frame(width: 56)
                }
                
                Spacer().frame(width: 16)
            }
        }
        .padding(.horizontal, 40)
    }
    
    private func numberButton(action: @escaping () -> Void, number: Int) -> some View {
        Button(action: action) {
            Text("\(number)")
                .font(type: .omyu, size: 34)
                .foregroundColor(UIColor.Gray.gray900.color)
                .frame(width: 85, height: 85)
                .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                .clipShape(Circle())
        }
    }
}

#Preview {
    var viewModel = SettingViewModel()
    viewModel.appPassWord = []
    
    return LockSettingView(viewModel: viewModel)
}
