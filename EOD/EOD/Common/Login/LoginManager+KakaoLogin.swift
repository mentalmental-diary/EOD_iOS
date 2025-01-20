//
//  LoginManager+KakaoLogin.swift
//  EOD
//
//  Created by JooYoung Kim on 12/16/24.
//
#if !PREVIEW
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

extension LoginManager {
    func getKakaoOathToken(completion: @escaping ((Result<String, Error>) -> Void)) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    errorLog(error.localizedDescription)
                    completion(.failure(error))
                }
                if let oauthToken = oauthToken {
                    completion(.success(oauthToken.accessToken))
                    debugLog("카카오 로그인 토큰 : \(oauthToken)")
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    errorLog(error.localizedDescription)
                }
                if let oauthToken = oauthToken {
                    debugLog("kakao success")
                    debugLog("카카오 로그인 토큰 : \(oauthToken)")
                    completion(.success(oauthToken.accessToken))
                }
            }
        }
    }
}
#endif
