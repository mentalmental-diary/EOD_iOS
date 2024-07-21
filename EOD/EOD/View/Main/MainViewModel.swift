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
    
    var presentLoginView: Bool = false // 로그인뷰가 노출되어있는지 확인 -> 회원가입뷰에서 왔다갔다 하기 위해
    var presentSignUpView: Bool = false // 회원가입뷰가 노출되어있는지 확인 -> 로그인뷰와 왔다갔다 하기 위해
    
    init() {
        isLogin = LoginManager.shared.isLogin ?? false
    }
    
    func loginAction() {
        presentLoginView = false // 로그인 성공시
        presentSignUpView = false // 로그인 성공시
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
