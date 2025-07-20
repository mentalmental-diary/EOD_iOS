//
//  EODApp.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import SwiftUI
import UIKit
#if !PREVIEW
import KakaoSDKAuth
#endif
/// AppDelegate  대신해서 완성하기 -> SiwftUI 하고 UIKit 연동하기 위해서?
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 0.1)
        
        return true
    }
    
    // MARK: - Push Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationManager.shared.didRegisterForRemoteNotification(tokenData: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        infoLog("fail to register for remote notifications. error : \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        debugLog("[Push] didReceiveNotification - app running")
        NotificationManager.shared.didReceiveRemoteNotification(application: application, userInfo: userInfo)
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
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        AppDelegate.orientationLock = .portrait
        
        BootLoader.runBootLoaderModules()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: {
                    // 여기서 Login여부 판단 후 넘어가야함
                })
                .onOpenURL { url in
                    debugLog("🔵 콜백 URL호출. url: \(url.absoluteString)")
#if !PREVIEW
                    // 카카오 로그인 URL 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    
                    // 네이버 로그인 URL 처리
                    if url.absoluteString.contains("eodnaverlogin://") {
                        LoginManager.shared.receiveAccessToken(url)
                    }
#endif
                }
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
