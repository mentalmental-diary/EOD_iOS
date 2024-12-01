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
            
            if currentShowType == .item {
                self.selectThemeItemList = self.originalThemeItemList
            } else {
                self.selectThemeItemList = nil
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
                    self.fetctThemeItemList(id: selectTheme?.id ?? 0)
                } else {
                    self.fetchShopThemeItemList(id: selectTheme?.id ?? 0)
                }
            }
        }
    }
    
    @Published var selectThemeItemList: [ThemeItem]? = [] // 현재 선택되있는 테마 아이템 리스트
    
    @Published var selectThemeItem: ThemeItem?
    
    @Binding var userGold: Int? // 현재 유저가 보유하고 있는 골드
    
    var originalThemeItemList: [ThemeItem]? = [] // 최초 유저가 설정해둔 테마 아이템 리스트
    
    private let networkModel: ShowRoomNetworkModel = ShowRoomNetworkModel()
    
    init(userGold: Binding<Int?>, userThemeList: [ThemeItem]? = nil) {
        self._userGold = userGold
        self.selectThemeItemList = userThemeList
        self.originalThemeItemList = userThemeList
        
        self.fetchThemeList()
    }
}

// func
extension HouseViewModel {
    // 보유아이템/상점 둘다 공통으로 사용하는 함수 -> 테마 목록 리스트는 상점 리스트 한번만 호출 (최초 한번)
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
    
    func fetctThemeItemList(id: Int) {
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
    
    func fetchShopThemeItemList(id: Int) {
        networkModel.fetchShopThemeItemList(id: id, completion: { [weak self] result in
            debugLog("테마 상점 아이템 리스트 호출 API 완료 result: \(result)")
            
            switch result {
            case .success(let list):
                debugLog("테마 상점 아이템 리스트 호출 API 성공. 리스트 목록 : \(list)")
                self?.themeShopItemList = list
            case .failure(let error):
                errorLog("임시로 일단 에러 확인용 error: \(error)") // TODO: 향후 토스트 메시지로 변경 예정 일단 테스트용
            }
        })
    }
    
    func setSelectThemeItem(item: ThemeItem) {
        self.selectThemeItem = selectThemeItem == item ? nil : item
    }
}

extension HouseViewModel {
    var isModify: Bool { return self.originalThemeItemList != self.selectThemeItemList } // 수정여부 확인
    
    var presentItemList: [ThemeItem]? { return self.currentShowType == .item ? self.themeItemList : self.themeShopItemList }
}
