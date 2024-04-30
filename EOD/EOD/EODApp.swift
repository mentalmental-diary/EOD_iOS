//
//  EODApp.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import SwiftUI
import UIKit

/// AppDelegate  대신해서 완성하기 -> SiwftUI 하고 UIKit 연동하기 위해서?
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        Thread.sleep(forTimeInterval: 0.1) // TODO: 여기서 최대 3초 핸들링 진행 -> 근데 굳이 그건 필요 없을 것 같고 적당한 시간 런치로 보여준다 느낌으로 진행 -> 짧아도 괜찮을듯
        
        return true
    }
}

@main
struct EODApp: App {
    // appDelegate 적용
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // sceneDelegate 적용
    @Environment(\.scenePhase) private var scenePhase
    
    /// 앱에서 처음에 기본 세팅해야하는 부분에 대해서 이곳에서 처리 , UIKit에서 Appdelegate 가 이부분이라고 생각하면됨
    /// 기본 configuration들을 여기서 관리하자 -> 모듈화 좋은 생각
    init() {
        BootLoader.runBootLoaderModules()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                AppManager.shared.isActive = true
                debugLog("앱 활성화")
            case .inactive:
                infoLog("앱이 \(AppManager.shared.isActive ? "background" : "foreground")에 진입합니다.")
            case .background:
                AppManager.shared.isActive = false
                debugLog("앱 비활성화")
            @unknown default:
                errorLog("의도치 않은 상태")
            }
        }
    }
}

/// Foreground -> Background 또는 Background -> Foreground 를 알아내기 위한 싱글톤 객체
class AppManager {
    var isActive = false
    static var shared = AppManager()
    private init() {}
}
