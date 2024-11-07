//
//  HouseViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class HouseViewModel: ObservableObject {
    @Published var currentShowType: ShowType = .item
    
    @Published var themeList: [Theme]? = [] // 테마 리스트
    
    @Published var themeItemList: [ThemeItem]? = [] // 각 테마 진입시 노출되는 아이템 리스트 (보유 아이템)
    
    @Published var themeShopItemList: [ShopThemeItem]? = [] // 각 테마 상점 진입시 노출되는 아이템 리스트
    
    @Published var selectTheme: Theme? // 선택된 테마
}
