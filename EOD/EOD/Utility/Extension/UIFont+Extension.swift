//
//  UIFont+Extension.swift
//  EOD
//
//  Created by JooYoung Kim on 1/14/25.
//

import UIKit

extension UIFont {
    
    /// UIFont를 생성한다.
    ///
    /// - Parameters:
    ///   - type: 폰트 타입. FontType중 하나를 선택한다. (애플 산돌고딕네오, 샌프란시스코, 타임즈 뉴 로만)
    ///   - fontSize: 폰트 사이즈
    ///   - weight: 굵기 정도. .light, .thin, .light, .regular, .medium, .semibold, .bold
    public class func font(type: FontType = .pretendard, size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        guard let fontName = type.fontName(weight: weight, size: size), let font = UIFont(name: fontName, size: size) else {
            debugLog("Not supported font. type = \(String(describing: type)), weight = \(weight)")
            
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
        
        return font
    }
    
    /// Bold font를 생성한다.
    public class func boldFont(type: FontType = .pretendard, size: CGFloat) -> UIFont {
        return font(type: type, size: size, weight: .bold)
    }
    
    /// Semi bold font를 생성한다.
    public class func semiBoldFont(type: FontType = .pretendard, size: CGFloat) -> UIFont {
        return font(type: type, size: size, weight: .semibold)
    }
}

extension UIFont {
    
    /// 현재의 폰트를 기반으로 텍스트의 크기를 구한다.
    ///
    /// - Parameters:
    ///   - text: 길이를 구할 텍스트
    ///   - maxWidth: 최대 가로길이.
    /// - Returns: CGSize
    public func calculateSize(from text: String, maxWidth: CGFloat = CGFloat.infinity) -> CGSize {
        let size = text.boundingRect(with: CGSize(width: maxWidth, height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self], context: nil).size
        
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}

public enum FontType {
    case sdGothic       // 애플 산돌고딕네오
    case pretendard
    case omyu
    
    public func fontName(weight: UIFont.Weight, size: CGFloat = 16.0) -> String? {
        switch self {
        case .sdGothic:       return Self.sdGothicFontName(weight: weight)
        case .pretendard:     return Self.pretendardFontName(weight: weight)
        case .omyu:           return "omyu pretty"
        }
    }
    
    public static func pretendardFontName(weight: UIFont.Weight) -> String {
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
    
    public static func sdGothicFontName(weight: UIFont.Weight) -> String {
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

// MARK: - pretendard font
extension UIFont {
    private static var pretendardFontNames: [String] {
        var names: [String] = []
        let baseName = "Pretendard-"
        
        names.append(baseName + "Black")
        names.append(baseName + "ExtraBold")
        names.append(baseName + "Bold")
        names.append(baseName + "SemiBold")
        names.append(baseName + "Medium")
        names.append(baseName + "Regular")
        names.append(baseName + "Light")
        names.append(baseName + "ExtraLight")
        names.append(baseName + "Thin")
        
        return names
    }
}
