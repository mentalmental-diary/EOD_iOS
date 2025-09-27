//
//  RoomThemeEnums.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation

public enum RoomThemeItemType: String, CaseIterable, Decodable {
    case backGround = "BACK_GROUND"
    case wallpaper = "WALLPAPER"
    case flooring = "FLOORING"
    case parts1 = "PARTS1"
    case parts2 = "PARTS2"
    case parts3 = "PARTS3"
    case parts4 = "PARTS4"
    case parts5 = "PARTS5"
    case parts6 = "PARTS6"
    case parts7 = "PARTS7"
    
    public var imageName: String {
        switch self {
        case .backGround: return "default_background"
        case .wallpaper: return "default_wall"
        case .flooring: return "default_floor"
        default: return ""
        }
    }
    
    public var frameSize: CGSize? {
        switch self {
        case .wallpaper: return CGSize(width: 252, height: 230)
        case .flooring: return CGSize(width: 269, height: 113) // TODO: 여기 사이즈값을 고정으로 가도되는지 나중에 확인좀 해보기
        case .parts1: return CGSize(width: 90, height: 68)
        case .parts2: return CGSize(width: 90, height: 68)
        case .parts3: return CGSize(width: 90, height: 90)
        case .parts4: return CGSize(width: 90, height: 90)
        case .parts5: return CGSize(width: 90, height: 90)
        case .parts6: return CGSize(width: 90, height: 90)
        case .parts7: return CGSize(width: 90, height: 90)
        default: return nil
        }
    }
    
    public func frameSize(for viewType: HousePreviewViewType) -> CGSize? {
        switch self {
        case .wallpaper:
            switch viewType {
            case .home: return CGSize(width: 336, height: 306)
            case .house: return CGSize(width: 252, height: 230)
            }
        case .flooring:
            switch viewType {
            case .home: return CGSize(width: 358, height: 150)
            case .house: return CGSize(width: 269, height: 113)
            }
        case .parts1: return CGSize(width: 90, height: 68)
        case .parts2: return CGSize(width: 90, height: 68)
        case .parts3: return CGSize(width: 90, height: 90)
        case .parts4: return CGSize(width: 90, height: 90)
        case .parts5: return CGSize(width: 90, height: 90)
        case .parts6: return CGSize(width: 90, height: 90)
        case .parts7: return CGSize(width: 90, height: 90)
        default: return nil
        }
    }
}
