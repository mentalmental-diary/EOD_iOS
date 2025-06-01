//
//  GameInfoAlertView.swift
//  EOD
//
//  Created by JooYoung Kim on 5/24/25.
//

import SwiftUI

struct GameInfoAlertView: View {
    @Binding var isShow: Bool
    var imageName: String
    var limitTime: Int
    var gameDescription: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("게임 방법")
                        .font(type: .omyu, size: 28)
                        .foregroundColor(.black)
                        .underlinedBackground()
                    
                    Spacer().frame(height: 16)
                    
                    Image(imageName)
                        .resizable()
                        .frame(width: 303, height: 160)
                    
                    Spacer().frame(height: 16)
                    
                    Text("제한시간 \(limitTime)초")
                        .font(type: .omyu, size: 16)
                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                        .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                        .clipShape(Capsule())
                    
                    Spacer().frame(height: 16)
                    
                    Text(gameDescription)
                        .font(type: .omyu, size: 18)
                        .foregroundColor(UIColor.Gray.gray900.color)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 24)
                    
                    Button {
                        isShow = false
//                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("이해했어요!")
                            .font(type: .omyu, size: 20)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 35)
                            .background(.black)
                            .cornerRadius(8)
                    }

                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 16)
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
    GameInfoAlertView(isShow: .constant(false), imageName: "catchyolk_game_info", limitTime: 3, gameDescription: "asdf")
}
