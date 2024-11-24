//
//  HomeViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var userGold: Int = 0
    
    private var networkModel: HomeNetworkModel = HomeNetworkModel()
    
    init() {
        self.fetchUserGold()
        self.fetchUserInfo()
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
        networkModel.fetchUserInfo { result in
            debugLog("유저 정보 조회 API 호출 완료 result: \(result)")
            switch result {
            case .success(let info):
                debugLog("현재 설정된 정보 : \(info)")
                
            case .failure(let error):
                errorLog("유저가 설정한 캐릭터 및 테마 조회 API 실패. error: \(error.localizedDescription)")
            }
        }
    }
}
