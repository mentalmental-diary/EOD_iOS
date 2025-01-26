//
//  CustomStartAlert.swift
//  EOD
//
//  Created by JooYoung Kim on 1/25/25.
//

import SwiftUI

struct CustomStartAlert: View {
    @Binding var showAlert: Bool
    
    var body: some View {
        ZStack {
            Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image("welcome")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 105, height: 91)
                    
                    Spacer().frame(height: 42)
                    
                    Text("노른자의 하루에 오신 걸 환영해요!")
                        .font(size: 22)
                        .foregroundColor(.black)
                    
                    Spacer().frame(height: 16)
                    
                    Text("오늘 일기를 써볼까요?")
                        .font(size: 20)
                        .foregroundColor(UIColor.Gray.gray700.color)
                    
                    Spacer().frame(height: 28)
                    
                    Button(action: {
                        withAnimation {
                            showAlert = false
                        }
                    }) {
                        Text("확인")
                            .font(size: 20)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .background(.black)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 11)
                .padding(.top, 48)
                .padding(.bottom, 13)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white)
                .cornerRadius(15)
                .transition(.scale)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    CustomStartAlert(showAlert: .constant(false))
}
