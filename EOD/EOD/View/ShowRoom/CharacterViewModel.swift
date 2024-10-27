//
//  CharacterViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class CharacterViewModel: ObservableObject {
    @Published var currentShowType: ShowType = .item
}

enum ShowType: String {
    case item
    case shop
    
    var description: String {
        switch self {
        case .item: return "보유 아이템"
        case .shop: return "상점"
        }
    }
}
