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
    
    @Published var showGoldInfoView: Bool = false {
        didSet {
            guard oldValue != showGoldInfoView else { return }
            
            if showGoldInfoView {
                self.fetchGoldTransaction()
            }
        }
    }
    
    @Published var currentInfoTab: GoldInfoType = .all
    
    @Published var goldInfoList: [GoldInfoModel] = []
    
    private var networkModel: HomeNetworkModel = HomeNetworkModel()
    
    init() {
        self.fetchUserGold()
        self.fetchUserInfo()
        self.fetchComment()
    }
}

// MARK: - API 호출 함수들
extension HomeViewModel {
    /// 사용자 골드 정보 조회
    public func fetchUserGold() {
        networkModel.fetchUserGold { [weak self] result in
            DispatchQueue.main.async {
                debugLog("보유 Gold 조회 API 호출 완료 result: \(result)")
                switch result {
                case .success(let gold):
                    self?.userGold = gold["gold"] ?? 0
                case .failure(let error):
                    errorLog("보유 Gold 조회 API 실패. error: \(error)")
                }
            }
        }
    }
    
    /// 사용자 캐릭터 및 테마 정보 조회
    public func fetchUserInfo() {
        networkModel.fetchUserInfo { [weak self] result in
            DispatchQueue.main.async {
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
    }
    
    /// 사용자 한줄 메시지 조회
    public func fetchComment() {
        networkModel.fetchComment { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comment):
                    debugLog("유저 한줄 메시지 조회 성공: comment: \(comment)")
                    self?.userComment = comment
                case .failure(let error):
                    errorLog("유저 한줄 메시지 조회 실패. error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 골드 사용내역 조회
    public func fetchGoldTransaction() {
        networkModel.fetchGoldTransaction { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    debugLog("골드 사용내역 조회 model: \(model)")
                    self?.goldInfoList = model
                case .failure(let error):
                    errorLog("유저 골드 사용내역 조회 실패. error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 모든 홈 데이터 새로고침 (홈 탭 진입 시 호출)
    public func refreshAllData() {
        debugLog("홈 탭 데이터 새로고침 시작")
        fetchUserGold()
        fetchUserInfo()
        fetchComment()
    }
    
    /// 캐릭터/테마 변경 후 정보 갱신
    public func refreshUserInfo() {
        fetchUserInfo()
        fetchUserGold()
    }
}

public enum GoldInfoType {
    case all
    case earn
    case use
    
    public var title: String {
        switch self {
        case .all: return "전체"
        case .earn: return "적립"
        case .use: return "사용"
        }
    }
}

extension GoldInfoModel.TransactionType {
    var displayTitle: String {
        switch self {
        case .gameCharge: return "게임 플레이"
        case .diaryCharge: return "일기 작성"
        case .purchaseItem: return "아이템 구매"
        }
    }
}

extension GoldInfoModel {
    var amountString: String {
        let sign = amount > 0 ? "+" : "-"
        return "\(sign)\(abs(amount).formattedDecimal()) 골드"
    }
}

extension GoldInfoModel {
    static func mockDataList() -> [GoldInfoModel] {
        let types: [TransactionType] = [.gameCharge, .diaryCharge, .purchaseItem]
        var models: [GoldInfoModel] = []

        for i in 1...30 {
            let type = types[i % types.count]
            let amount = type == .purchaseItem ? -(1000 * (i % 5 + 1)) : (1000 * (i % 5 + 1))
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())

            let model = GoldInfoModel.mock(
                id: i,
                userNo: 123,
                transactionType: type,
                amount: amount,
                createdAt: date
            )
            models.append(model)
        }

        return models
    }

    static func mock(id: Int, userNo: Int, transactionType: TransactionType, amount: Int, createdAt: Date?) -> GoldInfoModel {
        let model = GoldInfoModel(id: id, userNo: userNo, transactionType: transactionType, amount: amount, createdAt: createdAt)
        return model
    }

    private convenience init(id: Int, userNo: Int, transactionType: TransactionType, amount: Int, createdAt: Date?) {
        self.init()
        self.id = id
        self.userNo = userNo
        self.transactionType = transactionType
        self.amount = amount
        self.createdAt = createdAt
    }
}

class MockHomeViewModel: HomeViewModel {
    override init() {
        super.init()
        self.userGold = 12345
        self.goldInfoList = GoldInfoModel.mockDataList()
    }
}
