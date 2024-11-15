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
}
