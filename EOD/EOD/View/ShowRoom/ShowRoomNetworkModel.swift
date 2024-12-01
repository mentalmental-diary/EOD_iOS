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
    func testFetchCharacterItemList(completion: @escaping ((Result<[CharacterItem], Error>) -> Void)) {
        let api = "/api-external/user/rewards/api-external/user/rewards/character"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    // TODO: 일단 페이징 전 API테스트
    func testFetchShopCharacterItemList(completion: @escaping ((Result<[CharacterItem], Error>) -> Void)) {
        let api = "/api-external/shop/character"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    /// 보유아이템/상점 테마 목록은 공통으로 사용
    func fetchThemeList(completion: @escaping ((Result<[Theme], Error>) -> Void)) {
        let api = "/api-external/shop/room/theme"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func fetchThemeItemList(id: Int, completion: @escaping ((Result<[ThemeItem], Error>) -> Void)) {
        let api = "/api-external/user/rewards/api-external/user/rewards/theme/\(id)"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func fetchShopThemeItemList(id: Int, completion: @escaping ((Result<[ThemeItem], Error>) -> Void)) {
        let api = "/api-external/shop/room/theme/\(id)"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func buyCharacterItem(id: Int, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let api = "/api-external/shop/trade/character/\(id)"
        
        APIRequest.requestDecodable(api: api, method: .post, completion: completion)
    }
    
    func buyThemeItem(id: Int, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let api = "/api-external/shop/trade/room/\(id)"
        
        APIRequest.requestDecodable(api: api, method: .post, completion: completion)
    }
}
