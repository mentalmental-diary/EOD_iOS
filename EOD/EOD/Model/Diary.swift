//
//  Diary.swift
//  EOD
//
//  Created by JooYoung Kim on 6/10/24.
//

import Foundation

struct Diary {
    var date: Date? = Date()
    var emotion: EmotionType?
    var diaryContents: String? // 일기 내용 (최대 2000자)
}
