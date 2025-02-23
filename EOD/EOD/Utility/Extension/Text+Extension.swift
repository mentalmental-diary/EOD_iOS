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
        guard let fontName = type.fontName(weight: weight, size: size) else {
            debugLog("Not supported font. type = \(String(describing: type)), weight = \(weight)")
            return font(.system(size: size))
        }
        return font(.custom(fontName, size: size))
    }
    
    /// 폰트 설정 (lineHeight, kerning)
//    public func font(weight: Font.Weight = .regular, size: CGFloat, lineHeight: CGFloat, kerning: CGFloat = -0.3) -> some View {
//        let uiFontHeight = UIFont.font(size: size, weight: weight.uikitConverted).lineHeight
//        
//        let heightDiff: CGFloat = lineHeight > uiFontHeight ? lineHeight - uiFontHeight : 0
//        
//        return self.font(weight: weight, size: size)
//            .kerning(kerning)
//            .lineSpacing(heightDiff)
//            .padding(.vertical, heightDiff / 2)
//    }
}

public enum FontType {
    case sdGothic       // 애플 산돌고딕네오
    case pretendard
    case omyu
    case cafe24Ssurround
    
    public func fontName(weight: Font.Weight, size: CGFloat = 16.0) -> String? {
        switch self {
        case .sdGothic:       return Self.sdGothicFontName(weight: weight)
        case .pretendard:     return Self.pretendardFontName(weight: weight)
        case .omyu:           return "omyu pretty"
        case .cafe24Ssurround: return "Cafe24Ssurround"
        }
    }
    
    public static func pretendardFontName(weight: Font.Weight) -> String {
        let baseName = "Pretendard-"
        
        switch weight {
        case .black:      return baseName + "Black"
        case .heavy:      return baseName + "ExtraBold"
        case .bold:       return baseName + "Bold"
        case .semibold:   return baseName + "SemiBold"
        case .medium:     return baseName + "Medium"
        case .regular:    return baseName + "Regular"
        case .light:      return baseName + "Light"
        case .ultraLight: return baseName + "ExtraLight"
        case .thin:       return baseName + "Thin"
        
        default:
            warningLog("Pretendard 폰트에서 지원하지 않는 weight입니다. Regular 타입을 리턴합니다. weight = \(weight)")
            return baseName + "Regular"
        }
    }
    
    public static func sdGothicFontName(weight: Font.Weight) -> String {
        // ["AppleSDGothicNeo-Bold", "AppleSDGothicNeo-UltraLight", "AppleSDGothicNeo-Thin", "AppleSDGothicNeo-Regular", "AppleSDGothicNeo-Light", "AppleSDGothicNeo-Medium", "AppleSDGothicNeo-SemiBold"]
        let baseName = "AppleSDGothicNeo-"
        
        switch weight {
        case .ultraLight: return baseName + "UltraLight"
        case .thin:       return baseName + "Thin"
        case .light:      return baseName + "Light"
        case .regular:    return baseName + "Regular"
        case .medium:     return baseName + "Medium"
        case .semibold:   return baseName + "SemiBold"
        case .bold:       return baseName + "Bold"
            
        default:
            warningLog("애플고딕에서 지원하지 않는 weight입니다. Regular 타입을 리턴합니다. weight = \(weight)")
            return baseName + "Regular"
        }
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
