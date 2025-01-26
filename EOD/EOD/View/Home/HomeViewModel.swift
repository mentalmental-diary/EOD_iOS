//
//  HomeViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var userGold: Int? = 0
    
    @Published var userCharacterInfo: CharacterItem?
    
    @Published var userThemeList: [ThemeItem]?
    
    @Published var userComment: String?
    
    private var networkModel: HomeNetworkModel = HomeNetworkModel()
    
    init() {
        self.fetchUserGold()
        self.fetchUserInfo()
        self.fetchComment()
    }
}

/// Func
extension HomeViewModel {
    private func fetchUserGold() {
        networkModel.fetchUserGold { result in
            debugLog("보유 Gold 조회 API 호출 완료 result: \(result)")
            switch result {
            case .success(let gold):
                self.userGold = gold["gold"] ?? 0
            case .failure(let error):
                errorLog("보유 Gold 조회 API 실패. error: \(error)")
            }
        }
    }
    
    private func fetchUserInfo() {
        networkModel.fetchUserInfo { [weak self] result in
            debugLog("유저 정보 조회 API 호출 완료 result: \(result)")
            switch result {
            case .success(let info):
                debugLog("현재 설정된 정보 : \(info.characterInfo), \(info.roomItems)")
                
                self?.userThemeList = Array(info.roomItems.values)
                self?.userCharacterInfo = info.characterInfo
            case .failure(let error):
                errorLog("유저가 설정한 캐릭터 및 테마 조회 API 실패. error: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchComment() {
        networkModel.fetchComment { [weak self] result in
            switch result {
            case .success(let comment):
                debugLog("유저 한줄 메시지 조회 성공: comment: \(comment)")
                self?.userComment = comment
            case .failure(let error):
                errorLog("유저 한줄 메시지 조회 실패. error: \(error.localizedDescription)")
            }
        }
    }
    
    public func refreshUserInfo() {
        self.fetchUserInfo()
        self.fetchUserGold()
    }
    
    func testAddGold() {
        networkModel.addGold(completion: { [weak self] result in
            switch result {
            case .success:
                self?.fetchUserGold()
            case .failure(let error):
                errorLog("충전 안됨 error: \(error)")
            }
        })
    }
}
