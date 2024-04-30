//
//  View+Extension.swift
//  EOD
//
//  Created by USER on 2023/10/08.
//

import SwiftUI

/// Modifier 사용
extension View {
    func showIf(condition: Bool) -> AnyView {
        if condition {
            return AnyView(self)
        } else {
            return AnyView(EmptyView())
        }
    }
    
    func toast(message: String, isShowing: Binding<Bool>) -> some View {
        self.modifier(ToastModifier(message: message, isShowing: isShowing))
    }
}

/// ViewBuilder
extension View {
    /// view custom hidden
    @ViewBuilder func visibility(_ visibility: Bool) -> some View {
        if visibility {
            self
        } else {
            hidden()
        }
    }
}
