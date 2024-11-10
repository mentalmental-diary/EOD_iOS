//
//  RoomThemeEnums.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation

public enum RoomThemeItemType: String, CaseIterable, Decodable {
    case wallpaper = "WALLPAPER"
    case flooring = "FLOORING"
    case window = "WINDOW"
    case nightstand = "NIGHTSTAND"
    case sofa = "SOFA"
    case frame = "FRAME"
    case table = "TABLE"
    case stand_light = "STAND_LIGHT"
    case rug = "RUG"
}
