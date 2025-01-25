//
//  ToastManager.swift
//  EOD
//
//  Created by JooYoung Kim on 1/25/25.
//

import SwiftUI
import Foundation

final class ToastManager: ObservableObject {
    static let shared = ToastManager() // 싱글톤
    @Published private(set) var isShowing: Bool = false
    @Published private(set) var message: String = ""
    private(set) var visibleIcon: Bool = false

    private var toastQueue: [(String, Bool)] = [] // (메시지, visibleIcon) 큐
    private var isDisplaying: Bool = false // 현재 토스트가 표시 중인지 상태

    private init() {}

    /// 토스트 메시지 추가
    func showToast(message: String, visibleIcon: Bool = true) {
        // 큐에 추가
        toastQueue.append((message, visibleIcon))
        displayNextToast() // 다음 토스트를 표시
    }

    /// 큐에서 다음 토스트를 표시
    private func displayNextToast() {
        // 현재 토스트가 표시 중이거나 큐가 비어 있다면 아무 작업도 하지 않음
        guard !isDisplaying, let nextToast = toastQueue.first else { return }
        isDisplaying = true // 토스트 표시 상태 업데이트
        toastQueue.removeFirst() // 큐에서 현재 메시지 제거

        // 상태 업데이트
        self.message = nextToast.0
        self.visibleIcon = nextToast.1
        withAnimation(.easeInOut(duration: 0.6)) {
            self.isShowing = true
        }

        // 일정 시간 후 토스트 숨김 처리 및 다음 토스트 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { // 토스트 노출 시간: 2.5초
            self.hideToast {
                self.isDisplaying = false
                self.displayNextToast() // 다음 토스트 표시
            }
        }
    }

    /// 토스트 숨김 처리
    func hideToast(completion: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.6)) {
            self.isShowing = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: completion) // 애니메이션 종료 후 처리
    }
    
    // MARK: - Preview Helper
    static func previewInstance(isShowing: Bool, message: String, visibleIcon: Bool) -> ToastManager {
        let manager = ToastManager()
        manager.isShowing = isShowing
        manager.message = message
        manager.visibleIcon = visibleIcon
        return manager
    }
}
