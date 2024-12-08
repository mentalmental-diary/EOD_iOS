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
    var isClicked: Bool?
    
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
        isClicked = try container.decodeIfPresent(Bool.self, forKey: .isClicked)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageUrl
        case name
        case createdAt
        case isClicked
    }
}

extension Theme: Equatable {
    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }
}

extension Theme: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: - 룸 테마 아이템 모델

/// 룸 테마 아이템 모델
struct ThemeItem: Decodable {
    var id: Int
    var type: RoomThemeItemType
    var itemImageUrl: String
    var homeImageUrl: String
    var name: String
    var isClicked: Bool?
    var price: Int?
    var themeId: Int?
    var details: String?
    var hasItem: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        type = try container.decode(RoomThemeItemType.self, forKey: .type)
        itemImageUrl = try container.decode(String.self, forKey: .itemImageUrl)
        homeImageUrl = try container.decode(String.self, forKey: .homeImageUrl)
        name = try container.decode(String.self, forKey: .name)
        isClicked = try container.decodeIfPresent(Bool.self, forKey: .isClicked)
        price = try container.decodeIfPresent(Int.self, forKey: .price)
        themeId = try container.decodeIfPresent(Int.self, forKey: .themeId)
        details = try container.decodeIfPresent(String.self, forKey: .details)
        hasItem = try container.decodeIfPresent(Bool.self, forKey: .hasItem)
        
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
        case itemImageUrl
        case homeImageUrl
        case name
        case isClicked
        case price
        case themeId
        case details
        case hasItem
        case createdAt
        case updatedAt
    }
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
