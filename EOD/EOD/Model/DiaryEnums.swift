//
//  DiaryEnums.swift
//  EOD
//
//  Created by JooYoung Kim on 6/4/24.
//

import Foundation

public enum EmotionType: Int, CaseIterable, CustomStringConvertible, Decodable {
    case happy
    case angry
    case relax
    case nomoral
    case sad
    case excited
    case proud
    case worry
    
    public var description: String {
        switch self {
        case .angry: return "화나"
        case .excited: return "신나"
        case .happy: return "행복해"
        case .nomoral: return "그저 그래"
        case .proud: return "뿌듯해"
        case .relax: return "마음 편해"
        case .sad: return "슬퍼"
        case .worry: return "걱정이야"
        }
    }
    
    public var imageName: String {
        switch self {
        case .angry: return "icon_angry"
        case .excited: return "icon_excited"
        case .happy: return "icon_happy"
        case .nomoral: return "icon_nomoral"
        case .proud: return "icon_proud"
        case .relax: return "icon_relax"
        case .sad: return "icon_sad"
        case .worry: return "icon_worry"
        }
    }
    
    public var selectImageName: String {
        switch self {
        case .angry: return "select_angry"
        case .excited: return "select_excited"
        case .happy: return "select_happy"
        case .nomoral: return "select_nomoral"
        case .proud: return "select_proud"
        case .relax: return "select_relax"
        case .sad: return "select_sad"
        case .worry: return "select_worry"
        }
    }
}
