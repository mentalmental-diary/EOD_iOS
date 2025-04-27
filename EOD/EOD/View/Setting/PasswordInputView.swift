//
//  PasswordInputView.swift
//  EOD
//
//  Created by JooYoung Kim on 4/6/25.
//

import SwiftUI

struct PasswordInputView: View {
    
    @Binding var password: [Int]
    @Binding var title: String
    @Binding var visibleWarningMessage: Bool
    
    var appendAction: ((_ number: Int) -> Void)
    var removeAction: (() -> Void)
    
    var body: some View {
        VStack {
            Text(title)
                .font(type: .omyu, size: 20)
                .foregroundColor(.black)
            
            Spacer().frame(height: 24)
            
            inputPasswordView()
            
            if visibleWarningMessage {
                Spacer().frame(height: 20)
                
                Text("비밀번호가 일치하지 않아요.")
                    .font(type: .omyu, size: 18)
                    .foregroundColor(Color(red: 255/255, green: 64/255, blue: 64/255))
                
                Spacer().frame(height: 69)
                
            } else {
                Spacer().frame(height: 100)
            }
            
            numberPadView()
            
            Spacer().frame(height: 64)
            
        }
        .padding(.top, 40)
    }
}

extension PasswordInputView {
    private func inputPasswordView() -> some View {
        HStack(spacing: 7) {
            Spacer()
            
            ForEach(0..<4, id: \.self) { index in
                if index < password.count {
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
                            appendAction(num)
                        }, number: num)
                    }
                }
            }
            
            HStack(spacing: 0) {
                Spacer().frame(width: 105)
                
                numberButton(action: {
                    appendAction(0)
                }, number: 0)
                
                Spacer().frame(width: 34)
                
                Button {
                    removeAction()
                } label: {
                    Image("btn_remove")
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
    PasswordInputView(password: .constant([]), title: .constant("비밀번호를 입력해주세요."), visibleWarningMessage: .constant(false), appendAction: { number in
        
    }, removeAction: {
        
    })
}
