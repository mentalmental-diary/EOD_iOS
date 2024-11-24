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
    
    @Published var isToast: Bool = false
    
    var originalCharacter: CharacterItem?
    
    var toastMessage: String = ""
    
    private var networkModel: ShowRoomNetworkModel = ShowRoomNetworkModel()
    
    init(userItems: [CharacterItem]? = nil, shopItems: [CharacterItem]? = nil) {
        if let userItems = userItems { // Preview용
            self.userItems = userItems
        }
        
        if let shopItems = shopItems {
            self.shopItems = shopItems
        }
        
        self.fetchCharacterItem()
        self.fetchShopCharacterItem() // TODO: 어처피 초기 화면 진입시엔 보유아이템이 메인이라면 상점 관련된건 상점 탭 눌렀을떄 해도 되지 않을까? -> 하지만 초기에 그냥 다 받아오는것도 나쁘진 않아 보이는데 일단 시점은 고민해보기
    }
}

extension CharacterViewModel {
    func fetchCharacterItem() {
        networkModel.testFetchCharacterItemList(completion: { [weak self] result in
            debugLog("API 호출 완료 result: \(result)")
            switch result {
            case .success(let list):
                debugLog("보유 캐릭터 아이템 조회 API 성공 data: \(list)")
                self?.userItems = list
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
                debugLog("상점 캐릭터 아이템 조회 API 성공 data: \(list)")
                self?.shopItems = list
            case .failure(let error):
                warningLog("상점 캐릭터 아이템 조회 API 실패 error: \(error)")
            }
        })
    }
    
    func setCharacterItem() {
        // TODO: 저장 로직 구현
        
        self.toastMessage = "대표 캐릭터로 저장되었습니다!"
        withAnimation(.easeInOut(duration: 0.6)) {
            self.isToast = true
        }
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
