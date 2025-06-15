//
//  KeyboardHeightHelper.swift
//  EOD
//
//  Created by JooYoung Kim on 6/15/25.
//

import Combine
import SwiftUI

final class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification))
            .sink { notification in
                guard let userInfo = notification.userInfo else { return }

                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
                let screenHeight = UIScreen.main.bounds.height

                if notification.name == UIResponder.keyboardWillHideNotification {
                    self.keyboardHeight = 0
                } else {
                    self.keyboardHeight = screenHeight - endFrame.origin.y
                }
            }
            .store(in: &cancellableSet)
    }
}
