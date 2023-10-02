//
//  UserManager.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    var id: String
    var password: String
    var isLogin: Bool
    var accessToken: String
    
    init() {
        if UserDefaults.standard.bool(forKey: "isLogin") == true {
            self.isLogin = true
            self.id = UserDefaults.standard.string(forKey: "id") ?? ""
            self.password = UserDefaults.standard.string(forKey: "password") ?? ""
            self.accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        } else {
            self.isLogin = false
            self.id = ""
            self.password = ""
            self.accessToken = ""
        }
    }
}
