//
//  HomeViewModel.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation

// MARK: - TAB ITEM CASE
enum Tab: String {
    case home = "home"
}

class HomeViewModel: ObservableObject {
    @Published var currentTab: Tab = .home
}
