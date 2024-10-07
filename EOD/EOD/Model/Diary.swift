//
//  Diary.swift
//  EOD
//
//  Created by JooYoung Kim on 6/10/24.
//

import Foundation

struct Diary: Decodable {
    var id: Int?
    var userNo: Int?
    var writeDate: Date? = Date()
    var seq: Int?
    var isCustomEmotion: Bool? = false // TODO: 나중에 바뀔 수 있는 변수
    var emotion: EmotionType?
    var title: String? = "" // TODO: 추후 삭제 예정
    var content: String? = "" // 일기 내용 (최대 2000자)
}
