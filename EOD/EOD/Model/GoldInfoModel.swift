//
//  GoldInfoModel.swift
//  EOD
//
//  Created by JooYoung Kim on 6/15/25.
//

import Foundation

class GoldInfoModel: Decodable {
    var id: Int
    var userNo: Int
    var transactionType: TransactionType
    var amount: Int
    var createdAt: Date?
    
    enum TransactionType: String, Decodable {
        case gameCharge = "GAME_CHARGE"
        case diaryCharge = "DIARY_CHARGE"
        case purchaseItem = "PURCHASE_ITEM"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case userNo
        case transactionType
        case amount
        case createdAt
    }
    
    init() {
        id = 0
        userNo = 0
        transactionType = .gameCharge
        amount = 0
        createdAt = nil
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userNo = try container.decode(Int.self, forKey: .userNo)
        self.transactionType = try container.decode(GoldInfoModel.TransactionType.self, forKey: .transactionType)
        self.amount = try container.decode(Int.self, forKey: .amount)
        createdAt = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .createdAt) else { return nil }
            return dateString.dateInKoreaTimeZone
        }()
    }
}
