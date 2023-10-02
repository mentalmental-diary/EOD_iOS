//
//  MainViewModel.swift
//  EOD
//
//  Created by Joo Young Kim on 2023/09/23.
//

import Foundation
import SwiftUI

// MARK: - TAB ITEM CASE
enum Tab: String {
    case home = "home"
}

class MainViewModel: ObservableObject {
    @Published var currentTab: Tab = .home
    @Published var isLogin: Bool = false
    
    init() {
        isLogin = LoginManager.shared.isLogin ?? false
    }
}
