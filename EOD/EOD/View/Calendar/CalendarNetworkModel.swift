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
        parameters["isCustomEmotion"] = false
        parameters["emotion"] = uploadDiary.emotion?.rawValue
        parameters["content"] = uploadDiary.content
        parameters["customEmotion"] = false // TODO: 해당 내용 중복된 것 같으니까 패스
        
        debugLog("다이어리 추가 API 파라미터: \(parameters)")
        
        APIRequest.requestDecodable(api: api, method: .post, requestParameters: parameters, completion: completion)
    }
    
    func modifyDiary(modifyDiary: Diary, completion: @escaping ((Result<Diary, Error>) -> Void)) {
        let api = "/api-external/diary/\(String(describing: modifyDiary.id))"
        
        var parameters: [String: Any] = [:]
        
        parameters["writeDate"] = modifyDiary.writeDate?.apiParameter
        parameters["seq"] = modifyDiary.seq
        parameters["isCustomEmotion"] = false
        parameters["emotion"] = modifyDiary.emotion?.rawValue
        parameters["content"] = modifyDiary.content
        parameters["customEmotion"] = false // TODO: 해당 내용 중복된 것 같으니까 패스
        
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
