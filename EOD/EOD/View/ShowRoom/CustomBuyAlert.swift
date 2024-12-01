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
            
            VStack {
                VStack(spacing: 0) {
                    
                    KFImage(imageUrl?.url)
                        .resizable()
                    
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
    CustomBuyAlert(showAlert: .constant(false))
}
