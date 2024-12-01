//
//  CharacterItem.swift
//  EOD
//
//  Created by JooYoung Kim on 10/27/24.
//

import Foundation

/// 캐릭터 아이템 모델
struct CharacterItem: Decodable {
    var id: Int
    var imageUrl: String?
    var name: String
    var details: String?
    var price: Int?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: Int, imageUrl: String, name: String, details: String? = "", price: Int? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
        self.details = details
        self.price = price
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decodeIfPresent(String.self, forKey: .details)
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
        case details
        case price
        case createdAt
        case updatedAt
    }
}

extension CharacterItem: Equatable {
    
    public static func == (lhs: CharacterItem, rhs: CharacterItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension CharacterItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
