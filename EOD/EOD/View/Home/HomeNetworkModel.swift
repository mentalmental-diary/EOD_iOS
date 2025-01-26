//
//  HomeNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 11/15/24.
//

import Foundation

class HomeNetworkModel {
    func fetchUserGold(completion: @escaping (Result<[String: Int], Error>) -> Void) {
        let api = "/api-external/user/rewards/gold"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func fetchUserInfo(completion: @escaping (Result<UserInfoModel, Error>) -> Void) {
        let api = "/api-external/user/rewards"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func addGold(completion: @escaping (Result<Void, Error>) -> Void) {
        let api = "/api-external/user/rewards/gold"
        
        APIRequest.requestData(api: api, method: .post, requestParameters: ["money": 1000], completion: { result in
            completion(result.voidMap())
        })
    }
    
    func fetchComment(completion: @escaping (Result<String, Error>) -> Void) {
        let api = "/api-external/user/comment"
        
        APIRequest.requestData(api: api, completion: { result in
            switch result {
            case .success(let comment):
                debugLog("한줄 메시지 조회 API 성공. comment: \(comment)")
                if let responseString = String(data: comment, encoding: .utf8) {
                    completion(.success(responseString))
                } else {
                    completion(.failure(CommonError.failedToFetch)) // 적절한 오류 처리
                }
            case .failure(let error):
                errorLog("한줄 메시지 조회 API 실패. error: \(error)")
                completion(.failure(error))
            }
        })
    }
}
