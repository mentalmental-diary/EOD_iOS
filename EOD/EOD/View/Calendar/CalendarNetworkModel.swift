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
        
        let parameters: [String: Any] = ["yearMonth": yearMonth]
        
        APIRequest.requestDecodable(api: api, requestParameters: parameters, completion: completion)
    }
    
    func uploadDiary(uploadDiary: Diary, completion: @escaping ((Result<Diary, Error>) -> Void)) {
        let api = "api-external/diary"
        
        var parameters: [String: Any] = [:]
        
        parameters["writeDate"] = uploadDiary.writeDate?.apiParameter
        parameters["seq"] = 0
        parameters["isCustomEmotion"] = false
        parameters["emotion"] = uploadDiary.emotion?.rawValue
        parameters["content"] = uploadDiary.content
        parameters["customEmotion"] = false // TODO: 해당 내용 중복된 것 같으니까 패스
        
        debugLog("다이어리 추가 API 파라미터: \(parameters)")
        
        APIRequest.requestDecodable(api: api, method: .post, parameters: parameters, completion: completion)
        
    }
}
