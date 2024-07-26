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
    case Game = "game"
    case Shop = "shop"
    case My = "my"
    
    var title: String {
        switch self {
        case .Home: return "홈"
        case .Calender: return "캘린더"
        case .Game: return "게임"
        case .Shop: return "상점"
        case .My: return "마이페이지"
        }
    }
    
    var iconName: String {
        switch self {
        case .Home: return "icon_home"
        case .Calender: return "icon_calander"
        case .Game: return "icon_game"
        case .Shop: return "icon_shop"
        case .My: return "icon_my"
        }
    }
}
