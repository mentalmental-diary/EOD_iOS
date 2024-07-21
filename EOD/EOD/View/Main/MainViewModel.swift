//
//  MainViewModel.swift
//  EOD
//
//  Created by Joo Young Kim on 2023/09/23.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isLogin: Bool = false
    @Published var currentTab: Tab = .Home
    @Published var confirmEmail: Bool = false
    @Published var confirmTerms: Bool = false
    
    @Published var isShowAlert: Bool = false
    
    init() {
        isLogin = LoginManager.shared.isLogin ?? false
    }
    
    func loginAction() {
        isLogin.toggle()
    }
}

// MARK: - TAB ITEM CASE
enum Tab: String {
    case Home = "home"
    case Calender = "calender"
    case Report = "report"
    case Setting = "setting"
}
