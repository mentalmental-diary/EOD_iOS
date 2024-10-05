//
//  DiarySummaryModel.swift
//  EOD
//
//  Created by JooYoung Kim on 8/27/24.
//

import Foundation

struct DiarySummaryModel: Decodable {
    var data: [DiarySummary]
    
    var status: Int
    var message: String
}

public struct DiarySummary: Decodable {
    var id: Int
    var userNo: Int
    var writeDate: Date
    var emotion: EmotionType
    var content: String
}
