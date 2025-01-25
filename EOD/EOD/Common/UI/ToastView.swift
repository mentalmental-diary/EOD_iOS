//
//  ToastView.swift
//  EOD
//
//  Created by USER on 2023/10/08.
//

import SwiftUI

struct ToastView: View {
    @ObservedObject var toastManager: ToastManager

    var body: some View {
        VStack {
            if toastManager.isShowing {
                Group {
                    HStack(spacing: 8) {
                        if toastManager.visibleIcon {
                            Image("icon_check")
                        }
                        Text(toastManager.message)
                            .font(size: 16)
                            .frame(height: 24)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(red: 65 / 255, green: 58 / 255, blue: 53 / 255, opacity: 0.7))
                    .cornerRadius(8)
                }
                .transition(.move(edge: .top).combined(with: .opacity)) // 위에서 아래로 이동
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
//            ToastView(message: message, visibleIcon: visibleIcon, isShowing: $isShowing)
        }
    }
}
struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 토스트가 표시되는 상태
            ToastPreviewWrapper(
                toastManager: ToastManager.previewInstance(
                    isShowing: true,
                    message: "This is a test toast with an icon",
                    visibleIcon: true
                )
            )
            .previewDisplayName("Toast Visible with Icon")

            // 토스트가 표시되지 않는 상태
            ToastPreviewWrapper(
                toastManager: ToastManager.previewInstance(
                    isShowing: false,
                    message: "This toast is hidden",
                    visibleIcon: false
                )
            )
            .previewDisplayName("Toast Hidden")
        }
    }
}

// ToastView를 Preview에서 테스트할 수 있는 Wrapper
struct ToastPreviewWrapper: View {
    @StateObject var toastManager: ToastManager

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all) // 배경을 보여주기 위한 설정

            ToastView(toastManager: toastManager)
        }
    }
}

//struct ToastView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToastView(message: "Toast메시지 테스트", isShowing: .constant(true))
//    }
//}
