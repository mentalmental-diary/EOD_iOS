//
//  Diary.swift
//  EOD
//
//  Created by JooYoung Kim on 6/10/24.
//

import Foundation

public struct Diary: Decodable {
    var id: Int?
    var userNo: Int?
    var writeDate: Date?
    var seq: Int?
    var isCustomEmotion: Bool? = false // TODO: 나중에 바뀔 수 있는 변수
    var emotion: EmotionType?
    var content: String? = "" // 일기 내용 (최대 2000자)
    
    enum CodingKeys: String, CodingKey {
        case id
        case userNo
        case writeDate
        case seq
        case isCustomEmotion
        case emotion
        case content
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.userNo = try container.decodeIfPresent(Int.self, forKey: .userNo)
        writeDate = {
            // 서버에서 한국시간 string으로 내려주면 한국 타임존의 Date로 변환
            guard let dateString = try? container.decode(String.self, forKey: .writeDate) else { return nil }
            return dateString.summaryDateInKoreaTimeZone
        }()
        self.seq = try container.decodeIfPresent(Int.self, forKey: .seq)
        self.isCustomEmotion = try container.decodeIfPresent(Bool.self, forKey: .isCustomEmotion)
        self.emotion = try container.decodeIfPresent(EmotionType.self, forKey: .emotion)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
    }
    
    public init() {
        
    }
}

extension Diary: Equatable {
    public static func == (lhs: Diary, rhs: Diary) -> Bool {
        lhs.id == rhs.id
        && lhs.userNo == rhs.userNo
        && lhs.writeDate == rhs.writeDate
        && lhs.seq == rhs.seq
        && lhs.emotion == rhs.emotion
        && lhs.content == rhs.content
    }
}
