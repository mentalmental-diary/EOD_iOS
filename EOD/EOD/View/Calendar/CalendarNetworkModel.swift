//
//  CalendarNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 8/24/24.
//

import Foundation

class CalendarNetworkModel {
    func fetchDayDiary(id: Int, completion: @escaping (Result<Diary, Error>) -> Void) {
        let api = "/api-external/diary/\(id)"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func fetchMonthDiary(yearMonth: String, completion: @escaping (Result<[DiarySummary], Error>) -> Void) {
        let api = "api-external/diary/month"
        
        let parameters: [String: Any] = ["yearMonth": yearMonth]
        
        debugLog("다이어리 조회 API 파라미터 : \(parameters)")
        
        APIRequest.requestDecodable(api: api, parameters: parameters, completion: completion)
    }
    
    func uploadDiary(uploadDiary: Diary, completion: @escaping ((Result<Diary, Error>) -> Void)) {
        let api = "api-external/diary"
        
        var parameters: [String: Any] = [:]
        
        parameters["writeDate"] = uploadDiary.writeDate?.apiParameter
        parameters["seq"] = 0
        parameters["emotion"] = uploadDiary.emotion?.rawValue
        parameters["diaryBackground"] = uploadDiary.diary_background?.rawValue
        parameters["content"] = uploadDiary.content
        
        debugLog("다이어리 추가 API 파라미터: \(parameters)")
        
        APIRequest.requestDecodable(api: api, method: .post, requestParameters: parameters, completion: completion)
    }
    
    func modifyDiary(modifyDiary: Diary, completion: @escaping ((Result<Diary, Error>) -> Void)) {
        guard let id = modifyDiary.id else { return }
        let api = "/api-external/diary/\(id)"
        
        var parameters: [String: Any] = [:]
        
        parameters["writeDate"] = modifyDiary.writeDate?.apiParameter
        parameters["emotion"] = modifyDiary.emotion?.rawValue
        parameters["diaryBackground"] = modifyDiary.diary_background?.rawValue
        parameters["content"] = modifyDiary.content
        
        debugLog("다이어리 수정 API 파라미터: \(parameters)")
        
        APIRequest.requestDecodable(api: api, method: .put, requestParameters: parameters, completion: completion)
    }
    
    func deleteDiary(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let api = "/api-external/diary/\(id)"
        
        APIRequest.requestData(api: api, method: .delete, completion: { result in
            completion(result.voidMap())
        })
    }
}
