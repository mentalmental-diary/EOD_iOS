//
//  LoginManager.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation
import NaverThirdPartyLogin

public class LoginManager: NSObject {
    static let shared = LoginManager()
    
    var isLogin: Bool?
    
    override init() {
        super.init()
        
        self.isLogin = UserDefaults.standard.bool(forKey: "isLogin") == true
    }
    
    static func naverConfigure() {
        NaverThirdPartyLoginConnection.getSharedInstance().isInAppOauthEnable = true
        NaverThirdPartyLoginConnection.getSharedInstance().isNaverAppOauthEnable = true
        
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = "eodnaverlogin"
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = "tzhZWFvwHUtzpFf9furT"
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = "m5nGe3alMH"
        NaverThirdPartyLoginConnection.getSharedInstance().appName = "노른자의 하루"
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = LoginManager.shared
    }
}
