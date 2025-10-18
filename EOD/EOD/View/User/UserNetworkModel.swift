//
//  UserNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 7/26/24.
//

import Foundation
import Alamofire

class UserNetworkModel {
    func fetchLogin(Authorization: String, type: LoginType, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/auth/sign-in/oauth2"
        
        let headers: HTTPHeaders = [
            "Authorization": Authorization
        ]
        
        let param = [
            "login-type": type.rawValue
        ]
        
        debugLog("로그인 API호출에 필요한 파라미터값. headers: \(headers), param: \(param)")
        
        let request = APIRequest.request(api: api, method: .post, parameters: param, headers: headers).0
        
        request.response(completionHandler: { [weak self] response in
            
            debugLog("로그인 API호출 완료 response: \(response)")
            
            guard let tokens = self?.fetchAccessToken(from: response) else {
                let error = response.parsedError
                completion(.failure(error))
                return
            }

            self?.setUserInfo(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
            completion(.success(()))
        })
    }
    
    func oldFetchSignin(email: String, password: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "api-external/auth/sign-in"
        
        let param = [
            "email": email,
            "password": password
        ]
        
        let request = APIRequest.request(api: api, method: .post, requestParameters: param).0
        
        request.response(completionHandler: { [weak self] response in
            
            debugLog("로그인 API호출 완료 response: \(response)")
            
            guard let tokens = self?.fetchAccessToken(from: response) else {
                let error = response.parsedError
                completion(.failure(error))
                return
            }

            self?.setUserInfo(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
            completion(.success(()))
        })
    }
    
    func fetchSignUp(email: String, password: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "api-external/auth/sign-up"
        
        debugLog("회원가입 API 호출")
        
        let param = [
            "email": email,
            "password": password
        ]
        
        APIRequest.requestData(api: api, method: .post, requestParameters: param, completion: { [weak self] result in
            
            debugLog("회원가입 API가 완료되었습니다. result: \(result)")
            guard let error = result.error else {
                self?.oldFetchSignin(email: email, password: password, completion: completion)
                
                return
            }
            
            debugLog("회원가입 API실패 error: \(error)")
            completion(.failure(error))
        })
    }
    
    func checkUserNickname(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let api = "/api-external/user/check-nickname"
        
        APIRequest.requestDecodable(api: api, completion: completion)
    }
    
    func setUserNickname(nickName: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/user/nickname"
        
        let param = [
            "nickName": nickName
        ]
        
        APIRequest.requestData(api: api, method: .put, requestParameters: param, completion: { result in
            completion(result.voidMap())
        })
    }
    
    private func fetchAccessToken(from response: AFDataResponse<Data?>) -> (accessToken: String, refreshToken: String)? {
        guard let accessToken = response.response?.allHeaderFields["Authentication"] as? String, !accessToken.isBlank,
              let refreshToken = response.response?.allHeaderFields["RefreshToken"] as? String, !refreshToken.isBlank else {
            warningLog("로그인 API에서 토큰 획득 실패.")
            return nil
        }
        
        debugLog("로그인 토큰 획득 성공")
        
        return (accessToken, refreshToken)
    }
    
    private func setUserInfo(accessToken: String, refreshToken: String) {
        UserDefaultsManager.shared.accessToken = accessToken
        UserDefaultsManager.shared.refreshToken = refreshToken
        UserDefaultsManager.shared.isLogin = true
    }
    
    func getUserNickname(completion: @escaping ((Result<String?, Error>) -> Void)) {
        let api = "/api-external/user/nickname"
        
        APIRequest.requestData(api: api) { result in
            switch result {
            case .success(let data):
                let nickname = String(data: data, encoding: .utf8)
                completion(.success(nickname))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postLeaveUser(completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/auth/leave"
        
        APIRequest.requestData(api: api, method: .post, completion: { result in
            completion(result.voidMap())
        })
    }
    
    func postLogout(completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "/api-external/auth/logout"
        
        APIRequest.requestData(api: api, method: .post, completion: { result in
            completion(result.voidMap())
        })
    }
    
    /// 사용자 번호(userNo) 조회
    /// - 골드 거래내역 API를 통해 userNo 추출
    func fetchUserNo(completion: @escaping ((Result<Int, Error>) -> Void)) {
        let api = "/api-external/user/rewards/gold/transaction"
        
        APIRequest.requestDecodable(api: api) { (result: Result<[GoldInfoModel], Error>) in
            switch result {
            case .success(let transactions):
                if let firstTransaction = transactions.first {
                    completion(.success(firstTransaction.userNo))
                } else {
                    // 거래내역이 없는 경우 - 골드 정보 API로 대체 시도
                    completion(.failure(CommonError.failedToFetch))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


public enum LoginType: String {
    case `self` = "SELF"
    case kakao = "KAKAO"
    case naver = "NAVER"
    case apple = "APPLE"
}
