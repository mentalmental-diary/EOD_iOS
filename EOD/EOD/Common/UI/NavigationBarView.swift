//
//  NavigationBarView.swift
//  EOD
//
//  Created by USER on 2023/10/04.
//

import SwiftUI

/// 공통으로 사용하게 될 네비게이션 Bar base View -> 향후엔 이미지좀 바꿔두자
struct NavigationBarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    /// 헤더 타이틀
    var title: String = ""
    
    var dismissAction: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .leading) {
            Button(action: {
                if dismissAction != nil {
                    dismissAction?()
                } else {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }, label: {
                Image("icon_back")
                    .frame(maxHeight: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0.0, leading: 13.0, bottom: 2.0, trailing: 16.0))
                    .foregroundColor(Color.black)
            })
            HStack(spacing: 0) {
                Spacer()
                Text(title)
                    .font(size: 28)
                    .kerning(0.0)
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .frame(height: 54)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.clear)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    @Environment(\.presentationMode) static var presentationMode: Binding<PresentationMode>
    
    static var previews: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                NavigationBarView(title: "알림")
            }
            .frame(width: proxy.size.width, alignment: .leading)
        }
        .previewLayout(.fixed(width: 375.0, height: 54.0))
    }
}

