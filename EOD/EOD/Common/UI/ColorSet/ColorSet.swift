//
//  ColorSet.swift
//  EOD
//
//  Created by JooYoung Kim on 5/3/24.
//

import UIKit
import SwiftUI

// MARK: - 컬러셋

public extension UIColor {
    
    /// Primary Color Set
    public enum Yellow: String, AssetColor {
        case yellow50, yellow100, yellow200, yellow300, yellow400, yellow500, yellow600, yellow700, yellow800, yellow900
    }
    
    /// Greyscale Color Set
    /// - Remark: Light/Dark 테마 컬러셋이 대응되어 있으나 송출앱에서는 Light 모드만을 지원한다.
    public enum Gray: String, AssetColor {
        case gray50, gray100, gray200, gray300, gray400, gray500, gray600, gray700, gray800, gray900
    }
}

// MARK: - 실제 Color값을 구해주는 protocol

/// 각 Colorset enum에서 적용하는 protocol. `rawValue` 값은 ColorSet.xcasset 에 추가한 이미지 이름과 동일해야 합니다.
public protocol AssetColor {
    var rawValue: String { get }
}

public extension AssetColor {
    /// UIKit용 `UIColor`
    var uiColor: UIColor? {
        UIColor(named: rawValue, in: Bundle.main, compatibleWith: nil)
    }
    
    /// SwiftUI 용 `Color`
    var color: Color {
        Color(uiColor ?? .clear)
    }
}
