//
//  ShowRoomNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 10/21/24.
//

import Foundation

class ShowRoomNetworkModel: ListNetworkModel {
    func fetchCharacterItemList(completion: @escaping ((Result<[CharacterItem], Error>) -> Void)) {
        let api = "/api-external/user/rewards/api-external/user/rewards/character"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func fetchShopCharacterItemList(completion: @escaping ((Result<[CharacterItem], Error>) -> Void)) {
        let api = "/api-external/shop/character"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    /// 보유아이템 테마 목록
    func fetchThemeList(completion: @escaping ((Result<[Theme], Error>) -> Void)) {
        let api = "/api-external/user/rewards/room/theme"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    /// 상점 테마 목록
    func fetchShopThemeList(completion: @escaping ((Result<[Theme], Error>) -> Void)) {
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
    
    func setCharacterItem(id: Int, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/user/rewards/character"
        
        let param = [
            "characterId": id
        ]
        
        APIRequest.requestData(api: api, method: .put, requestParameters: param, completion: { result in
            completion(result.voidMap())
        })
    }
    
    func setThemeItem(themeList: [ThemeItem], completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/user/rewards/room-info"
        
        // RoomThemeItemType의 모든 케이스를 초기값 0으로 가진 딕셔너리 생성
        var requestBody: [String: Int] = RoomThemeItemType.allCases.reduce(into: [:]) { result, type in
            switch type {
            case .wallpaper:
                result["roomWall"] = 0
            case .flooring:
                result["roomFlooring"] = 0
            case .backGround:
                result["roomBackground"] = 0
            default:
                result["room\(type.rawValue.capitalized)"] = 0
            }
        }
        
        // themeList를 순회하며 requestBody 업데이트
        for item in themeList {
            switch item.type {
            case .wallpaper:
                requestBody["roomWall"] = item.id
            case .flooring:
                requestBody["roomFlooring"] = item.id
            case .backGround:
                requestBody["roomBackground"] = item.id
            default:
                let key = "room\(item.type.rawValue.capitalized)"
                requestBody[key] = item.id
            }
        }
        
        APIRequest.requestData(api: api, method: .put, requestParameters: requestBody, completion: { result in
            completion(result.voidMap())
        })
    }
    
    func setCharacterItemClicked(id: Int, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/user/rewards/api-external/user/rewards/character/\(id)/click"
        
        APIRequest.requestData(api: api, method: .post, completion: { result in
            completion(result.voidMap())
        })
    }
    
    func setThemeItemClicked(id: Int, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/user/rewards/api-external/user/rewards/theme/item/\(id)/click"
        
        APIRequest.requestData(api: api, method: .post, completion: { result in
            completion(result.voidMap())
        })
    }
}
