//
//  Text+Extension.swift
//  EOD
//
//  Created by JooYoung Kim on 5/8/24.
//

import SwiftUI

extension Text {
    
    public func font(size: CGFloat) -> Text {
        return font(.custom("omyu pretty", size: size))
    }
    
    /// Pretendard  폰트 설정
    /// - Remark: 현재는 Pretendard 고정이지만 다른 폰트 설정이 필요하다면 enum으로 폰트 타입을 추가해서 개선할 예정.
    /// - Parameters:
    ///   - weight: Font Weight. 지정하지 않을 경우 regular 사용
    /// - Returns: Text
    public func font(type: FontType = .pretendard, weight: Font.Weight = .regular, size: CGFloat) -> Text {
        let fontString = FontType.pretendardFontName(weight: weight.uikitConverted)
        return font(.custom(fontString, size: size))
    }
    
    /// 폰트 설정 (lineHeight, kerning)
    public func font(weight: Font.Weight = .regular, size: CGFloat, lineHeight: CGFloat, kerning: CGFloat = -0.3) -> some View {
        let uiFontHeight = UIFont.font(size: size, weight: weight.uikitConverted).lineHeight
        
        let heightDiff: CGFloat = lineHeight > uiFontHeight ? lineHeight - uiFontHeight : 0
        
        return self.font(weight: weight, size: size)
            .kerning(kerning)
            .lineSpacing(heightDiff)
            .padding(.vertical, heightDiff / 2)
    }
}

private extension Font.Weight {
    /// SwiftUI의 Font.Weight를 UIKit의 UIFont.Weight로 변환한다.
    var uikitConverted: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        
        default:          return .regular
        }
    }
}
