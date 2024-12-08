//
//  BuyCompleteView.swift
//  EOD
//
//  Created by JooYoung Kim on 12/8/24.
//

import SwiftUI
import Kingfisher

struct BuyCompleteView: View {
    @Binding var showCompleteView: Bool
    
    var imageUrl: String?
    var itemName: String?
    var acceptAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
            
            VStack(spacing: 0) {
                ZStack {
                    Image("buy_complete")
                    Text("구매 완료!")
                        .font(size: 32)
                        .foregroundColor(.white)
                }
                
                KFImage(imageUrl?.url)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 91)
                
                Spacer().frame(height: 20)
                
                Button {
                    acceptAction?()
                    showCompleteView = false
                } label: {
                    Text("적용하러 가기")
                        .font(size: 20)
                        .padding(.vertical, 16)
                        .padding(.horizontal,27)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(8)
                }

                Spacer().frame(height: 16)
                
                Button {
                    cancelAction?()
                    showCompleteView = false
                } label: {
                    Text("나중에 적용하기")
                        .font(size: 16)
                        .underline()
                        .foregroundColor(.white)
                }

            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    BuyCompleteView(showCompleteView: .constant(false), imageUrl: "https://yolk-shop-image.kr.object.ncloudstorage.com/1_character/1-3_character2.webp?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20241201T085616Z&X-Amz-SignedHeaders=host&X-Amz-Expires=86399&X-Amz-Credential=9HwjhTcz2kypE8HXSl6d%2F20241201%2Fkr-standard%2Fs3%2Faws4_request&X-Amz-Signature=35be30a0cde40ce78937ee08ba507e92930912b75a348488b58495a68246242f")
}
