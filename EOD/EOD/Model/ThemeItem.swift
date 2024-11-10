//
//  ThemeItem.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation

/// 룸 테마 모델
struct Theme: Decodable {
    var id: Int
    var imageUrl: String
    var name: String
    var createdAt: Date?
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        name = try container.decode(String.self, forKey: .name)
        createdAt = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .createdAt) else { return nil }
            return dateString.dateInKoreaTimeZone
        }()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageUrl
        case name
        case createdAt
    }
}

struct ThemeModel: Decodable {
    var data: [Theme]
    
    var status: String
    var message: String
}

// MARK: - 룸 테마 아이템 모델

/// 룸 테마 아이템 모델
struct ThemeItem: Decodable {
    var id: Int
    var type: RoomThemeItemType
    var imageUrl: String
    var name: String
}

struct ThemeItemModel: Decodable {
    var data: [ThemeItem]
    
    var status: String
    var message: String
}

extension ThemeItem: Equatable {
    
    public static func == (lhs: ThemeItem, rhs: ThemeItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension ThemeItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


/// 상점 룸 테마 아이템 모델
struct ShopThemeItem: Decodable {
    var id: Int
    var type: RoomThemeItemType
    var themeId: Int
    var name: String
    var price: Int
    var imageUrl: String
    var details: String
    var createdAt: Date?
    var updatedAt: Date?
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        type = try container.decode(RoomThemeItemType.self, forKey: .type)
        themeId = try container.decode(Int.self, forKey: .themeId)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Int.self, forKey: .price)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        details = try container.decode(String.self, forKey: .details)
        
        createdAt = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .createdAt) else { return nil }
            return dateString.dateInKoreaTimeZone
        }()
        
        updatedAt = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .updatedAt) else { return nil }
            return dateString.dateInKoreaTimeZone
        }()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case themeId
        case name
        case price
        case imageUrl
        case details
        case createdAt
        case updatedAt
    }
}

struct ShopThemeItemModel: Decodable {
    var data: [Theme]
    
    var status: String
    var message: String
}
