//
//  ShowRoomNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import Foundation

class ShowRoomNetworkModel: ListNetworkModel {
    func fetchCharacterItemList(isRefresh: Bool, completion: @escaping ((Result<CharacterItem, Error>) -> Void)) {
        
    }
    
    // TODO: 일단 페이징 전 API테스트
    func testFetchCharacterItemList(completion: @escaping ((Result<CharacterItemModel, Error>) -> Void)) {
        let api = "/api-external/user/rewards/api-external/user/rewards/character"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    // TODO: 일단 페이징 전 API테스트
    func testFetchShopCharacterItemList(completion: @escaping ((Result<CharacterItemModel, Error>) -> Void)) {
        let api = "/api-external/shop/character"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
}
