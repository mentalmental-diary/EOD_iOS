//
//  DiarySummaryModel.swift
//  EOD
//
//  Created by JooYoung Kim on 8/27/24.
//

import Foundation

public struct DiarySummary: Decodable {
    var id: Int
    var userNo: Int
    var writeDate: Date?
    var emotion: EmotionType
    var content: String
    var diary_background: diaryBackgroundType? = .white
    
    enum CodingKeys: String, CodingKey {
        case id
        case userNo
        case writeDate
        case emotion
        case content
        case diary_background = "diaryBackground"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        userNo = try container.decode(Int.self, forKey: .userNo)
        writeDate = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .writeDate) else { return nil }
            return dateString.summaryDateInKoreaTimeZone
        }()
        emotion = try container.decode(EmotionType.self, forKey: .emotion)
        diary_background = try container.decodeIfPresent(diaryBackgroundType.self, forKey: .diary_background)
        content = try container.decode(String.self, forKey: .content)
    }
}
