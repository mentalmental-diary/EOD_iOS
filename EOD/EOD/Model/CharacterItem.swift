//
//  CharacterItem.swift
//  EOD
//
//  Created by JooYoung Kim on 10/27/24.
//

import Foundation

/// 캐릭터 아이템 모델
struct CharacterItem: Decodable {
    var id: Int?
    var imageUrl: String?
    var name: String?
}

struct CharacterItemModel: Decodable {
    var data: [CharacterItem]
    
    var status: String
    var message: String
}

/// 상점 캐릭터 아이템 모델
struct ShopCharacterItem: Decodable {
    var id: Int?
    var imageUrl: String?
    var name: String?
    var price: Int?
    var createdAt: Date?
    var updatedAt: Date?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(price, forKey: .price)
        try? container.encode(createdAt, forKey: .createdAt)
        try? container.encode(updatedAt, forKey: .updatedAt)
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        price = try container.decodeIfPresent(Int.self, forKey: .price)
        
        createdAt = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .createdAt) else { return nil }
            return dateString.dateInKoreaTimeZone
        }()
        updatedAt = {
            guard let dateString = try? container.decode(String.self, forKey: .updatedAt) else { return nil }
            return dateString.dateInKoreaTimeZone
        }()
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageUrl
        case name
        case price
        case createdAt
        case updatedAt
    }
}

struct ShopCharacterItemModel: Decodable {
    var data: [ShopCharacterItem]
    
    var status: String
    var message: String
}
