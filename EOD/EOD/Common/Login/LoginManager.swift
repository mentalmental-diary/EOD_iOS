//
//  LoginManager.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation
#if !PREVIEW
import NaverThirdPartyLogin
#endif
import Combine

public class LoginManager: NSObject, ObservableObject {
    static let shared = LoginManager()
    
    @Published var naverLoginResult: Result<String, Error>? = nil
    
    var isLogin: Bool?
    
    override init() {
        super.init()
        
        self.isLogin = UserDefaults.standard.bool(forKey: "isLogin") == true
    }
#if !PREVIEW
    static func naverConfigure() {
        NaverThirdPartyLoginConnection.getSharedInstance().isInAppOauthEnable = true
        NaverThirdPartyLoginConnection.getSharedInstance().isNaverAppOauthEnable = true
        
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = "eodnaverlogin"
        
        // ⚠️ 보안 주의: OAuth 키가 코드에 노출되어 있습니다.
        // 공개 저장소에 올라간 경우 키 재발급을 권장합니다.
        // TODO: 향후 .xcconfig 파일이나 환경변수로 관리 필요
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = "tzhZWFvwHUtzpFf9furT"
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = "m5nGe3alMH"
        
        NaverThirdPartyLoginConnection.getSharedInstance().appName = "노른자의 하루"
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = LoginManager.shared
    }
#endif
}
