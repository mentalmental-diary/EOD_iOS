//
//  LoginManager.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation

class LoginManager: NSObject {
    static let shared = LoginManager()
    
    var isLogin: Bool?
    
    override init() {
        super.init()
        
        self.isLogin = UserDefaults.standard.bool(forKey: "isLogin") == true
    }
}
