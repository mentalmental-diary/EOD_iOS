//
//  CharacterViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class CharacterViewModel: ObservableObject {
    @Published var currentShowType: ShowType = .item
    
    @Published var userItems: [CharacterItem]? = []
    
    @Published var shopItems: [CharacterItem]? = []
    
    @Published var selectItem: CharacterItem?
    
    private var networkModel: ShowRoomNetworkModel = ShowRoomNetworkModel()
    
    init(userItems: [CharacterItem]? = nil, shopItems: [CharacterItem]? = nil) {
        if let userItems = userItems { // Preview용
            self.userItems = userItems
        }
        
        if let shopItems = shopItems {
            self.shopItems = shopItems
        }
        self.fetchCharacterItem()
        self.fetchShopCharacterItem()
    }
}

extension CharacterViewModel {
    func fetchCharacterItem() {
        networkModel.testFetchCharacterItemList(completion: { [weak self] result in
            debugLog("API 호출 완료 result: \(result)")
            switch result {
            case .success(let list):
                debugLog("보유 캐릭터 아이템 조회 API 성공 data: \(list.data)")
                self?.userItems = list.data
            case .failure(let error):
                warningLog("보유 캐릭터 아이템 조회 API 실패 error: \(error)")
            }
        })
    }
    
    func fetchShopCharacterItem() {
        networkModel.testFetchShopCharacterItemList(completion: { [weak self] result in
            debugLog("상점 API 호출 완료 result: \(result)")
            switch result {
            case .success(let list):
                debugLog("상점 캐릭터 아이템 조회 API 성공 data: \(list.data)")
                self?.shopItems = list.data
            case .failure(let error):
                warningLog("상점 캐릭터 아이템 조회 API 실패 error: \(error)")
            }
        })
    }
}

/// Var
extension CharacterViewModel {
    var presentItemList: [CharacterItem]? {
        return self.currentShowType == .item ? userItems : shopItems
    }
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
