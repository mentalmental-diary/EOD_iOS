//
//  ToastView.swift
//  EOD
//
//  Created by USER on 2023/10/08.
//

import SwiftUI

struct ToastView: View {
    var message: String = ""
    var visibleIcon: Bool = false
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            if isShowing {
                Group {
                    HStack(spacing: 8) {
                        if visibleIcon {
                            Image("icon_check")
                        }
                        Text(message)
                            .font(size: 16)
                            .frame(height: 24)
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                    .padding(.vertical, 10)
                    .background(Color(red: 65/255, green: 58/255, blue: 53/255, opacity: 0.7))
                    .cornerRadius(8)
                }
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.6), value: isShowing) // TODO: 공통 토스트뷰로 다 동일한 효과로 가는지 확인
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            isShowing = false
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct ToastModifier: ViewModifier {
    var message: String
    var visibleIcon: Bool = false
    @Binding var isShowing: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
            ToastView(message: message, visibleIcon: visibleIcon, isShowing: $isShowing)
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "Toast메시지 테스트", isShowing: .constant(true))
    }
}
