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
    
    init() {
        isLogin = LoginManager.shared.isLogin ?? false
    }
    
    func test() {
        isLogin.toggle()
    }
}
