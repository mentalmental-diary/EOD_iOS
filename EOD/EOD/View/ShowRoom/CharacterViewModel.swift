//
//  CharacterViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class CharacterViewModel: ObservableObject {
    @Published var currentShowType: ShowType = .item {
        didSet {
            guard oldValue != currentShowType else { return }
            
            selectItem = nil
            
            if currentShowType == .item {
                self.fetchCharacterItem()
            } else {
                self.fetchShopCharacterItem()
            }
        }
    }
    
    @Published var userItems: [CharacterItem]? = []
    
    @Published var shopItems: [CharacterItem]? = []
    
    @Published var selectItem: CharacterItem?
    
    @Published var isToast: Bool = false
    
    @Published var userGold: Int? // 현재 유저가 보유하고 있는 골드
    
    @Published var showBuyCompleteView: Bool = false
    
    var originalCharacter: CharacterItem?
    
    var toastMessage: String = ""
    
    private var networkModel: ShowRoomNetworkModel = ShowRoomNetworkModel()
    
    init(userItems: [CharacterItem]? = nil, shopItems: [CharacterItem]? = nil, userGold: Int?) {
        if let userItems = userItems { // Preview용
            self.userItems = userItems
        }
        
        if let shopItems = shopItems {
            self.shopItems = shopItems
        }
        
        self.userGold = userGold
        
        self.fetchCharacterItem()
        self.fetchShopCharacterItem() // TODO: 어처피 초기 화면 진입시엔 보유아이템이 메인이라면 상점 관련된건 상점 탭 눌렀을떄 해도 되지 않을까? -> 하지만 초기에 그냥 다 받아오는것도 나쁘진 않아 보이는데 일단 시점은 고민해보기
    }
}

extension CharacterViewModel {
    func fetchCharacterItem() {
        networkModel.fetchCharacterItemList(completion: { [weak self] result in
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
        networkModel.fetchShopCharacterItemList(completion: { [weak self] result in
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
    
    func setSelectItem(item: CharacterItem) {
        if self.currentShowType == .item || item.hasItem != true { // 보유아이템 탭이거나 솔드아웃되지 않은 아이템인경우
            if self.currentShowType == .item {
                self.setCharacterItemClicked(item: item, then: {
                    self.selectItem = self.selectItem == item ? nil : item
                })
            } else {
                self.selectItem = self.selectItem == item ? nil : item
            }
        } else { // 솔드아웃된경우
            self.toastMessage = "이미 구매한 아이템입니다."
            withAnimation(.easeInOut(duration: 0.6)) {
                self.isToast = true
            }
        }
    }
    
    func setCharacterItem() {
        guard let id = selectItem?.id else { errorLog("선택된 아이템이 없습니다."); return }
        
        networkModel.setCharacterItem(id: id, completion: { [weak self] result in
            switch result {
            case .success:
                self?.toastMessage = "대표 캐릭터로 저장되었습니다!"
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
            case .failure(let error):
                errorLog("대표 캐릭터 저장 실패 error: \(error)")
                self?.toastMessage = "대표 캐릭터로 저장이 실패하였습니다."
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
            }
        })
    }
    
    func buyCharacterItem() {
        guard let id = selectItem?.id else { errorLog("선택된 아이템이 없습니다."); return }
        networkModel.buyCharacterItem(id: id, completion: { [weak self] result in
            debugLog("캐릭터 아이템 구매 API 호출 완료. result: \(result)")
            switch result {
            case .success(_):
                let resultGold = (self?.userGold ?? 0) - (self?.selectItem?.price ?? 0)
                self?.userGold = resultGold
                self?.showBuyCompleteView = true
                self?.selectItem = nil
            case .failure(let error):
                errorLog("캐릭터 아이템 구매 API 실패. error: \(error)")
            }
        })
    }
    
    func setCharacterItemClicked(item: CharacterItem, then: (() -> Void)?) {
        guard let userItems = userItems,
              let targetItem = userItems.first(where: { $0.id == item.id }) else {
            errorLog("아이템을 리스트에서 찾을 수 없습니다. id: \(item.id)")
            return
        }
        
        guard item.isClicked == false else { then?(); return } // 클릭이 안된 아이템인경우
        
        networkModel.setCharacterItemClicked(id: item.id, completion: { result in
            switch result {
            case .success:
                infoLog("아이템 뉴마커 처리 완료되었습니다. 뉴마커 제거된 아이템 : \(item.name)")
                
                targetItem.isClicked = true
                
                then?()
            case .failure(let error):
                errorLog("아이템 뉴마커 표시 제거 API실패. error: \(error)")
            }
        })
    }
    
    func buyCompleteAction() {
        self.currentShowType = .item // 보유아이템 탭으로 변경
    }
}

/// Var
extension CharacterViewModel {
    var presentItemList: [CharacterItem]? {
        return self.currentShowType == .item ? userItems : shopItems
    }
    
    /// 뉴마커 표시가 필요한 아이템 존재 여부
    var existNewItem: Bool {
        guard let items = self.userItems else { return false }
        
        return items.contains { $0.isClicked == false }
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
