//
//  CalendarNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 8/24/24.
//

import Foundation

class CalendarNetworkModel {
    func fetchMonthDiary(yearMonth: String, completion: @escaping (Result<DiarySummaryModel, Error>) -> Void) {
        let api = "api-external/diary/month"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func uploadDiary(uploadDiary: Diary, completion: @escaping ((Result<Diary, Error>) -> Void)) {
        
    }
}
