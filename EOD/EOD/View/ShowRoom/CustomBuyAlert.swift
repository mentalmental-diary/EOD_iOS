//
//  CustomBuyAlert.swift
//  EOD
//
//  Created by JooYoung Kim on 11/30/24.
//

import SwiftUI
import Kingfisher

struct CustomBuyAlert: View {
    @Binding var showAlert: Bool
    
    var imageUrl: String?
    var itemName: String?
    var itemDescription: String?
    var userGold: Int?
    var availableBuyButton: Bool = true
    var acceptAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    KFImage(imageUrl?.url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 105, height: 91)
                    
                    Spacer().frame(height: 36)
                    
                    Text(itemName ?? "아이템이름")
                        .font(size: 22)
                        .foregroundColor(.black)
                    
                    Spacer().frame(height: 16)
                    
                    Text(itemDescription ?? "아이템설명")
                        .font(size: 16)
                        .foregroundColor(UIColor.Gray.gray700.color)
                    
                    Spacer().frame(height: 18)
                    
                    HStack(spacing: 5) {
                        Image("icon_egg")
                        
                        Text(userGold?.formattedDecimal() ?? "0")
                            .font(size: 20)
                            .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 239/255, green: 239/255, blue: 228/255))
                    .clipShape(Capsule())
                    
                    Spacer().frame(height: 24)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation {
                                cancelAction?()
                                showAlert = false
                            }
                        }) {
                            Text("취소")
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
                            Text(availableBuyButton ? "구매하기" : "골드 부족")
                                .font(size: 20)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundColor(.white)
                                .background(availableBuyButton ? Color.black : Color(red: 211/255, green: 210/255, blue: 207/255))
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 11)
                .padding(.top, 52)
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
    CustomBuyAlert(showAlert: .constant(false), imageUrl: "https://yolk-shop-image.kr.object.ncloudstorage.com/1_character/1-3_character2.webp?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20241201T085616Z&X-Amz-SignedHeaders=host&X-Amz-Expires=86399&X-Amz-Credential=9HwjhTcz2kypE8HXSl6d%2F20241201%2Fkr-standard%2Fs3%2Faws4_request&X-Amz-Signature=35be30a0cde40ce78937ee08ba507e92930912b75a348488b58495a68246242f")
}
