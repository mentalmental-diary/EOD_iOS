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
    
    @Published var themeShopItemList: [ThemeItem]? = [] // 각 테마 상점 진입시 노출되는 아이템 리스트
    
    @Published var selectTheme: Theme? { // 선택된 테마
        didSet {
            if selectTheme != nil {
                self.fetctShopThemeItemList(id: selectTheme?.id ?? 0)
            }
        }
    }
    
    @Published var selectShopItem: ThemeItem?
    
    @Binding var userGold: Int? // 현재 유저가 보유하고 있는 골드
    
    private let networkModel: ShowRoomNetworkModel = ShowRoomNetworkModel()
    
    init(userGold: Binding<Int?>) {
        self._userGold = userGold
        
        self.fetchThemeList()
    }
}

// func
extension HouseViewModel {
    func fetchThemeList() {
        networkModel.fetchThemeList { [weak self] result in
            debugLog("테마 리스트 호출 API 완료 result: \(result)")
            
            switch result {
            case .success(let list):
                debugLog("테마 리스트 호출 API 성공. 리스트 목록 : \(list)")
                self?.themeList = list
            case .failure(let error):
                errorLog("임시로 일단 에러 확인용 error: \(error)") // TODO: 향후 토스트 메시지로 변경 예정 일단 테스트용
            }
        }
    }
    
    func fetctShopThemeItemList(id: Int) {
        networkModel.fetchShopThemeItemList(id: id, completion: { [weak self] result in
            debugLog("테마 아이템 리스트 호출 API 완료 result: \(result)")
            
            switch result {
            case .success(let list):
                debugLog("테마 아이템 리스트 호출 API 성공. 리스트 목록 : \(list)")
                self?.themeShopItemList = list
            case .failure(let error):
                errorLog("임시로 일단 에러 확인용 error: \(error)") // TODO: 향후 토스트 메시지로 변경 예정 일단 테스트용
            }
        })
    }
}
