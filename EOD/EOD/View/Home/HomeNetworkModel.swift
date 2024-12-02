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
}
