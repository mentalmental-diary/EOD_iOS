//
//  LoginManager+NaverLogin.swift
//  EOD
//
//  Created by JooYoung Kim on 12/15/24.
//

import NaverThirdPartyLogin

// MARK: - Public method
extension LoginManager {
    func login() {
        guard !isValidAccessTokenExpireTimeNow else {
            retreiveInfo()
            return
        }
        if isInstalledNaver {
            debugLog("🟢 네이버 앱 설치됨. 앱으로 로그인 진행.")
            NaverThirdPartyLoginConnection.getSharedInstance().requestThirdPartyLogin()
        } else {
            debugLog("🔴 네이버 앱이 설치되지 않음. 앱스토어로 이동.")
            NaverThirdPartyLoginConnection.getSharedInstance().openAppStoreForNaverApp()
        }
    }
    
    func logout() {
        NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
    }
    
    func unlink() {
        NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
    }
    
    func receiveAccessToken(_ url: URL) {
        debugLog("🔵 네이버 앱에서 호출된 콜백 URL: \(url)")
        
        guard url.absoluteString.contains("eodnaverlogin://") else { return }
        NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
    }
    
}

// MARK: - Private variable
private extension LoginManager {
    var isInstalledNaver: Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().isPossibleToOpenNaverApp()
    }
    
    var isValidAccessTokenExpireTimeNow: Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().isValidAccessTokenExpireTimeNow()
    }
}

// MARK: - Private method
private extension LoginManager {
    func retreiveInfo() {
        guard isValidAccessTokenExpireTimeNow,
              let tokenType = NaverThirdPartyLoginConnection.getSharedInstance().tokenType,
              let accessToken = NaverThirdPartyLoginConnection.getSharedInstance().accessToken else {
            debugLog("🔴 Access Token이 유효하지 않음. Refresh Token으로 갱신 요청 진행.")
            NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
            return
        }
        
        debugLog("정보가 제대로 넘어왔는지 확인 token: \(tokenType), accessToken: \(accessToken)") // TODO: 해당 로그 삭제 예정
        
        //        Task {
        //            do {
        //                var urlRequest = URLRequest(url: URL(string: "https://openapi.naver.com/v1/nid/me")!)
        //                urlRequest.httpMethod = "GET"
        //                urlRequest.allHTTPHeaderFields = ["Authorization": "\(tokenType) \(accessToken)"]
        //                let (data, _) = try await URLSession.shared.data(for: urlRequest)
        //                let response = try JSONDecoder().decode(NaverLoginResponse.self, from: data)
        //
        //            } catch {
        //                await NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
        //            }
        //        }
    }
}


extension LoginManager: NaverThirdPartyLoginConnectionDelegate {
    // Required
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        debugLog("네아로 토큰 발급 성공")
        retreiveInfo()
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 토큰 갱신시
        debugLog("네아로 토큰갱신")
        retreiveInfo()
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        // Logout
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        errorLog("네아로 에러 발생 error: \(error.localizedDescription)")
        // Error 발생
    }
    
    
    // Optional
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFinishAuthorizationWithResult recieveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailAuthorizationWithReceive recieveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
        
    }
}
