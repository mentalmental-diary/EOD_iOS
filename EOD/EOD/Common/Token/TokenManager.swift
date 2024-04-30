//
//  TokenManager.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation

class TokenManager: NSObject {
    static let shared = TokenManager()
    
    public private(set) var accessToken: String?
}
