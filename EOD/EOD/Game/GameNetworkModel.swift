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
    
    /// 게임에서 획득한 보상을 서버로 전송
    /// - Parameters:
    ///   - earnedGold: 획득한 골드
    ///   - completion: 완료 콜백
    func sendGameReward(earnedGold: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let api = "/api-external/user/rewards/gold"
        
        let requestParameters: [String: Any] = [
            "money": earnedGold
        ]
        
        APIRequest.requestData(
            api: api,
            method: .post,
            requestParameters: requestParameters,
            completion: { result in
                completion(result.voidMap())
            }
        )
    }
}
