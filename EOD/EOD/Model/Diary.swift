//
//  Diary.swift
//  EOD
//
//  Created by JooYoung Kim on 6/10/24.
//

import Foundation

struct Diary: Decodable {
    var writeDate: Date? = Date()
    var emotion: EmotionType?
    var content: String? = "" // 일기 내용 (최대 2000자)
    var id: Int?
    var userNo: Int?
    var seq: Int?
    var isCustomEmotion: Bool?
}
