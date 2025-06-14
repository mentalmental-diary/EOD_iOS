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
    
    func underlinedBackground(
        color: Color = UIColor.Yellow.yellow200.color,
        height: CGFloat = 9,
        offsetY: CGFloat = 8
    ) -> some View {
        self.modifier(UnderlinedBackground(color: color, height: height, offsetY: offsetY))
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

extension View {
    /// 키보드를 화면에서 제거
    public func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    public func emptyViewIfAvailable(_ isEmpty: Bool) -> some View {
        self.modifier(EmptyViewModifier(isEmpty: isEmpty))
    }
    
    // MARK: NotificationCenter
    public func onAppWillEnterForeground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            infoLog("앱이 Foreground로 올라왔습니다.")
            action()
        }
    }
    
    public func onAppDidBecameForeground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            infoLog("앱이 Active state로 변경되었습니다.")
            action()
        }
    }
    
    public func onAppWillEnterBackground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            infoLog("앱이 곧 active 상태를 resign합니다.")
            action()
        }
    }
    
    public func onAppDidEnterBackground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            infoLog("앱이 Background로 내려갔습니다.")
            action()
        }
    }
    
    // MARK: View Cycle
    func onAppearWithCount(_ action: @escaping ((Int) -> Void)) -> some View {
        modifier(AppearCount(action: action))
    }
    
    func onFirstAppear(_ action: @escaping (() -> Void)) -> some View {
        modifier(FirstAppear(action: action))
    }
}

struct EmptyViewModifier: ViewModifier {
    let isEmpty: Bool
    
    func body(content: Content) -> some View {
        if isEmpty {
            EmptyView()
        } else {
            content
        }
    }
}

/// 해당 View에 높이값을 반환
public struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    public init(height: Binding<CGFloat>) {
        self._height = height
    }
    
    public func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

private struct AppearCount: ViewModifier {
    let action: (Int) -> Void
    
    @State private var appearCount: Int = 0
    
    func body(content: Content) -> some View {
        content.onAppear {
            appearCount += 1
            action(appearCount)
        }
    }
}

private struct FirstAppear: ViewModifier {
    let action: () -> Void
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            
            hasAppeared = true
            action()
        }
    }
}

struct UnderlinedBackground: ViewModifier {
    var color: Color
    var height: CGFloat
    var offsetY: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    color
                        .frame(width: geometry.size.width, height: height)
                        .offset(x: 0, y: geometry.size.height - offsetY)
                }
            )
    }
}
