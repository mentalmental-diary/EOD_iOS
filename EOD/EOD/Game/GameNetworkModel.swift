//
//  GameNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 6/1/25.
//
import Foundation

class GameNetworkModel {
    func fetchUserGold(completion: @escaping (Result<[String: Int], Error>) -> Void) {
        let api = "/api-external/user/rewards/gold"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
}
