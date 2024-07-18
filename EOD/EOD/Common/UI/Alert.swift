//
//  Alert.swift
//  EOD
//
//  Created by JooYoung Kim on 7/16/24.
//

import SwiftUI

struct Alert: View {
    @Binding var showAlert: Bool
    var title: String = ""
    var message: String = ""
    var accept: String = ""
    var acceptAction: (() -> Void)?
    var cancel: String = ""
    var cancelAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
            
            VStack {
                VStack(spacing: 0) {
                    Text(title)
                        .font(size: 22)
                    
                    Spacer().frame(height: 19)
                    
                    Text(message)
                        .font(size: 16)
                    
                    Spacer().frame(height: 22)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation {
                                cancelAction?()
                                showAlert = false
                            }
                        }) {
                            Text(cancel)
                                .font(size: 20)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1) // 검정색 테두리
                                )
                        }
                        
                        Button(action: {
                            withAnimation {
                                acceptAction?()
                                showAlert = false
                            }
                        }) {
                            Text(accept)
                                .font(size: 20)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 11)
                .padding(.top, 34)
                .padding(.bottom, 13)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .transition(.scale)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    Alert(showAlert: .constant(false), title: "회원 가입을 그만 둘까요?", message: "그만 두기를 누르면 작성한 내용이 어쩌구 저쩌구", accept: "확인", cancel: "취소")
}
