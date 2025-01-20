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
            
            guard let accessToken = self?.fetchAccessToken(from: response) else {
                let error = response.parsedError
                completion(.failure(error))
                return
            }

            self?.setUserInfo(accessToken: accessToken)
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
            
            guard let accessToken = self?.fetchAccessToken(from: response) else {
                let error = response.parsedError
                completion(.failure(error))
                return
            }

            self?.setUserInfo(accessToken: accessToken)
            completion(.success(()))
        })
    }
    
    func fetchSignUp(email: String, password: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let api = "api-external/auth/sign-up"
        
        debugLog("이떄 들어온 값 확인 email: \(email), password: \(password)")
        
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
    
    private func fetchAccessToken(from response: AFDataResponse<Data?>) -> String? {
        guard let accessToken = response.response?.allHeaderFields["Authentication"] as? String, !accessToken.isBlank else {
            warningLog("로그인 API에서 토큰 획득 실패.")
            return nil
        }
        
        debugLog("accessToken확인 : \(accessToken)") // TODO: 나중에 삭제
        
        return accessToken
    }
    
    private func setUserInfo(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(true, forKey: "isLogin")
    }
}

public enum LoginType: String {
    case `self` = "SELF"
    case kakao = "KAKAO"
    case naver = "NAVER"
}
