//
//  HouseViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class HouseViewModel: ObservableObject {
    @Published var currentShowType: ShowType = .item {
        didSet {
            guard oldValue != currentShowType else { return } // 이전과 값이 달라질 경우에만 해당 로직 타기
            
            selectTheme = nil // 선택된 테마 초기화
            selectThemeItem = nil
            
            if currentShowType == .item {
                self.selectThemeItemList = self.originalThemeItemList
            } else {
                self.selectThemeItemList = []
            }
        }
    }
    
    @Published var themeList: [Theme]? = [] // 테마 리스트
    
    @Published var themeItemList: [ThemeItem]? = [] // 각 테마 진입시 노출되는 아이템 리스트 (보유 아이템)
    
    @Published var themeShopItemList: [ThemeItem]? = [] // 각 테마 상점 진입시 노출되는 아이템 리스트
    
    @Published var selectTheme: Theme? { // 선택된 테마
        didSet {
            if selectTheme != nil {
                if currentShowType == .item {
                    self.fetchThemeItemList(id: selectTheme?.id ?? 0)
                } else {
                    self.fetchShopThemeItemList(id: selectTheme?.id ?? 0)
                }
            } else {
                self.selectThemeItemList = self.originalThemeItemList
            }
        }
    }
    
    @Published var selectThemeItemList: [ThemeItem] = [] // 현재 선택되있는 테마 아이템 리스트
    
    @Published var selectThemeItem: ThemeItem? // 현재 선택된 상점 내 아이템
    
    @Published var userGold: Int? // 현재 유저가 보유하고 있는 골드
    
    @Published var showBuyCompleteView: Bool = false
    
    var originalThemeItemList: [ThemeItem] = [] // 최초 유저가 설정해둔 테마 아이템 리스트
    
    @Published var isToast: Bool = false
    
    var toastMessage: String = ""
    
    private let networkModel: ShowRoomNetworkModel = ShowRoomNetworkModel()
    
    init(userGold: Int?, userThemeList: [ThemeItem] = []) {
        self.userGold = userGold
        self.selectThemeItemList = userThemeList
        self.originalThemeItemList = userThemeList
        
        self.fetchThemeList()
    }
}

// func
extension HouseViewModel {
    // 보유아이템/상점 둘다 공통으로 사용하는 함수 -> 테마 목록 리스트는 상점 리스트 한번만 호출 (최초 한번)
    private func fetchThemeList() {
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
    
    private func fetchThemeItemList(id: Int) {
        networkModel.fetchThemeItemList(id: id, completion: { [weak self] result in
            debugLog("테마 아이템 리스트 호출 API 완료 result: \(result)")
            
            switch result {
            case .success(let list):
                debugLog("테마 아이템 리스트 호출 API 성공. 리스트 목록 : \(list)")
                self?.themeItemList = list
            case .failure(let error):
                errorLog("임시로 일단 에러 확인용 error: \(error)") // TODO: 향후 토스트 메시지로 변경 예정 일단 테스트용
            }
        })
    }
    
    private func fetchShopThemeItemList(id: Int) {
        networkModel.fetchShopThemeItemList(id: id, completion: { [weak self] result in
            debugLog("테마 상점 아이템 리스트 호출 API 완료 result: \(result)")
            
            switch result {
            case .success(let list):
                debugLog("테마 상점 아이템 리스트 호출 API 성공. 리스트 목록 : \(list)")
                self?.themeShopItemList = list
                self?.selectThemeItemList = list
            case .failure(let error):
                errorLog("임시로 일단 에러 확인용 error: \(error)") // TODO: 향후 토스트 메시지로 변경 예정 일단 테스트용
            }
        })
    }
    
    func fetchShopThemeItemList() {
        guard let id = self.selectTheme?.id else { return }
        
        self.fetchShopThemeItemList(id: id)
    }
    
    func setSelectThemeItem(item: ThemeItem) {
        if self.currentShowType == .item || item.hasItem != true { // 보유아이템 탭이거나 솔드아웃되지 않은 아이템인경우
            self.selectThemeItem = self.selectThemeItem == item ? nil : item
        } else { // 솔드아웃된경우
            self.toastMessage = "이미 구매한 아이템입니다."
            withAnimation(.easeInOut(duration: 0.6)) {
                self.isToast = true
            }
        }
    }
    
    func setSelectThemeItemList(item: ThemeItem) {
        self.setThemeItemClicked(item: item, then: {
            if let index = self.selectThemeItemList.firstIndex(where: { $0.id == item.id }) { // 존재하는 아이템인경우
                self.selectThemeItemList.remove(at: index)
            } else {
                self.selectThemeItemList.append(item)
            }
        })
    }
    
    func isSelectItem(item: ThemeItem) -> Bool {
        return self.selectThemeItemList.contains(where: { $0.id == item.id }) == true
    }
    
    func buyThemeItem() {
        guard let id = selectThemeItem?.id else { errorLog("선택된 아이템이 없습니다."); return }
        networkModel.buyThemeItem(id: id, completion: { [weak self] result in
            debugLog("테마 아이템 구매 API 호출 완료. result: \(result)")
            switch result {
            case .success(_):
                let resultGold = (self?.userGold ?? 0) - (self?.selectThemeItem?.price ?? 0)
                self?.userGold = resultGold
                self?.fetchThemeList()
                self?.showBuyCompleteView = true
                self?.selectThemeItem = nil
            case .failure(let error):
                errorLog("테마 아이템 구매 API 실패. error: \(error)")
            }
        })
    }
    
    func buyCompleteAction() {
        guard let theme = self.selectTheme else { return }
        
        self.currentShowType = .item // 보유아이템 탭으로 변경
        DispatchQueue.main.async { // main queue에서 안전하게 처리
            self.selectTheme = theme
        }
    }
    
    func setThemeItem() {
        networkModel.setThemeItem(themeList: selectThemeItemList, completion: { [weak self] result in
            switch result {
            case .success:
                self?.toastMessage = "현재 방 상태가 저장되었습니다!"
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
                
                self?.originalThemeItemList = self?.selectThemeItemList ?? []
            case .failure(let error):
                errorLog("테마 아이템 저장 API 실패 error: \(error)")
                self?.toastMessage = "방 상태 저장에 실패하였습니다."
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
            }
        })
    }
    
    func setThemeItemClicked(item: ThemeItem, then: (() -> Void)?) {
        guard let themeItemList = themeItemList,
              let targetItem = themeItemList.first(where: { $0.id == item.id }) else {
            errorLog("아이템을 리스트에서 찾을 수 없습니다. id: \(item.id)")
            return
        }
        
        guard item.isClicked == false else { then?(); return } // 클릭이 안된 아이템인경우
        
        networkModel.setThemeItemClicked(id: item.id, completion: { result in
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
}

extension HouseViewModel {
    var isModify: Bool { return self.originalThemeItemList != self.selectThemeItemList } // 수정여부 확인
    
    var presentItemList: [ThemeItem]? { return self.currentShowType == .item ? self.themeItemList : self.themeShopItemList }
    
    /// 뉴마커 표시가 필요한 아이템 존재 여부
    var existNewItem: Bool {
        guard let items = self.themeList else { return false }
        
        return items.contains { $0.isClicked == false }
    }
}
