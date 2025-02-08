//
//  DiaryEnums.swift
//  EOD
//
//  Created by JooYoung Kim on 6/4/24.
//

import Foundation

public enum EmotionType: String, CaseIterable, CustomStringConvertible, Decodable {
    case happy = "HAPPY"
    case angry = "ANGRY"
    case ease = "EASE"
    case soso = "SOSO"
    case sad = "SAD"
    case excited = "EXCITED"
    case fulfilled = "FULFILLED"
    case worried = "WORRIED"
    
    public var description: String {
        switch self {
        case .angry: return "화나"
        case .excited: return "신나"
        case .happy: return "행복해"
        case .soso: return "그저 그래"
        case .fulfilled: return "뿌듯해"
        case .ease: return "마음 편해"
        case .sad: return "슬퍼"
        case .worried: return "걱정이야"
        }
    }
    
    public var imageName: String {
        switch self {
        case .angry: return "icon_angry"
        case .excited: return "icon_excited"
        case .happy: return "icon_happy"
        case .soso: return "icon_soso"
        case .fulfilled: return "icon_fulfilled"
        case .ease: return "icon_ease"
        case .sad: return "icon_sad"
        case .worried: return "icon_worried"
        }
    }
    
    public var selectImageName: String {
        switch self {
        case .angry: return "select_angry"
        case .excited: return "select_excited"
        case .happy: return "select_happy"
        case .soso: return "select_soso"
        case .fulfilled: return "select_fulfilled"
        case .ease: return "select_ease"
        case .sad: return "select_sad"
        case .worried: return "select_worried"
        }
    }
}

public enum diaryBackgroundType: String, CaseIterable {
    case white
    case dot
    case gridBlue
    case gridBrown
    case gridRed
    case clover
    case checkBrown
    case checkPurple
    case ribbonRed
    case ribbonBlue
    case pink
    case yellow
    case green
    case blue
    case purple
    
    public var imageName: String {
        switch self {
        case .white: return "diary_white"
        case .dot: return "diary_dot"
        case .gridBlue: return "diary_grid_blue"
        case .gridBrown: return "diary_grid_brown"
        case .gridRed: return "diary_grid_red"
        case .clover: return "diary_clover"
        case .checkBrown: return "diary_check_brown"
        case .checkPurple: return "diary_check_purple"
        case .ribbonRed: return "diary_ribbon_red"
        case .ribbonBlue: return "diary_ribbon_blue"
        case .pink: return "diary_pink"
        case .yellow: return "diary_yellow"
        case .green: return "diary_green"
        case .blue: return "diary_blue"
        case .purple: return "diary_purple"
        }
    }
}
