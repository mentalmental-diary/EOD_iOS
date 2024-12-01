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
}
