//
//  NotificationManager.swift
//  EOD
//
//  Created by JooYoung Kim on 2/16/25.
//

import UIKit
import UserNotifications
import Combine

/// 푸시 알림에 대한 모든 처리를 담당합니다.
/// - 푸쉬 및 알림 관련 문서 (서버에서 작성, OSS권한 필요)
/// - Remark: Ref. https://oss.navercorp.com/tong/server/wiki/push,-%EC%95%8C%EB%A6%BC,-Data-model-%EC%A0%95%EC%9D%98
class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private let deviceTokenSubject = CurrentValueSubject<String?, Never>(nil)
   
    private var cancellables = Set<AnyCancellable>()
    
    private var userInfoBuffer: [AnyHashable: Any]?
    private var appStartedWithNotification = false
    
    let networkModel = NotificationNetworkModel()
    
    override init() {
        super.init()
        
        bind()
    }
    
    private func bind() {
        deviceTokenSubject
            .dropFirst() // 최초 초기 nil 값 스킵
            .removeDuplicates()
            .compactMap({ $0 }) // nil 값 제외
            .sink { [weak self] token in
                self?.requestBindDeviceToken(token: token)
            }
            .store(in: &cancellables)
        
        deviceTokenSubject
            .dropFirst() // 최초 초기 nil 값 스킵
            .removeDuplicates()
            .sink { [weak self] token in
                self?.backup(deviceToken: token)
            }
            .store(in: &cancellables)
    }
    
    /**
     사용자에게 푸쉬알림 권한을 요청
     
     iOS10~ : 사용자가 알림권한 요청 alert에서 OK를 하면 그 때, 토큰을 요청하고 바인딩API 요청을 한다.
     iOS9   : 사용자의 의사와 관계없이 토큰을 요청하고 바인딩API 요청을 한다.
     */
    private func registerNotification(completion: ((Bool) -> Void)? = nil) {
        debugLog("[Push]\nBundle ID: \(Bundle.main.bundleIdentifier ?? "")")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            // 푸쉬알림 권한 설정중 에러가 발생한 경우.
            if let error = error {
                errorLog("[Push] notification auth failed. granted: \(granted)\nError: \(String(describing: error))")
                return
            }
            
            if granted {
                infoLog("Push notifications permission authorized by user ✅")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    completion?(true)
                }
            } else {
                // 사용자가 DisAllow. 필요하다면 doSomethingToUsersWhoDeniedNotification()를 호출하도록.
                infoLog("Push notifications permission denied by user ⛔️")
                DispatchQueue.main.async { completion?(false) }
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerNotificationIfNeeded(completion: ((Bool) -> Void)? = nil) {
        registerNotification(completion: completion)
    }
    
    /**
     알림수신을 거부했던 사용자에게 액션을 취하고 싶다면 아래 메소드를 구현하면 됩니다.
     Ex) 서버와 협의 후 특정 배포버전에서는 푸쉬알림 권한을 재요청한다거나?
     */
    private func doSomethingToUsersWhoDeniedNotification() {
        
    }
    
    /**
     디바이스토큰이 정상적으로 발급된 뒤 호출되는 메소드
     */
    func didRegisterForRemoteNotification(tokenData: Data) {
        let deviceTokenString = tokenData.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        infoLog("[Push] \(#function) deviceToken : \(deviceTokenString)")
        
        deviceTokenSubject.send(deviceTokenString)
    }
    
    /**
     앱이 running상태일 때, 받은 푸쉬를 처리하는 메소드
     */
    func didReceiveRemoteNotification(application: UIApplication, userInfo: [AnyHashable: Any]) {
        // 푸쉬디버그가 힘들어서, 우선 모든 푸쉬데이터 nelo에 쌓음
        debugLog("[Push] Logging notification userInfo.\nuserInfo: \(userInfo.unicodeDecoded)")
        
        // 앱이 not running인 상태에서 푸쉬로 앱을 실행했다면, 브릿지 페이지까지 로딩이 완료된 뒤에 랜딩페이지로 이동한다.
        guard !appStartedWithNotification else {
            userInfoBuffer = userInfo
            return
        }
    }
    
    // 브릿지 페이지에서 호출하는 메소드. 앱 실행을 푸쉬알림으로 진행했다면 랜딩페이지로 이동한다.
    func checkAppExecutedByNotification() {
        guard appStartedWithNotification, let userInfo = userInfoBuffer else { return }
        
        infoLog("브릿지 페이지 로딩완료. 랜딩페이지로 이동합니다.")
        appStartedWithNotification = false
        
        parseUserInfoThenReadNotification(userInfo)
        userInfoBuffer = nil
    }
    
    /**
     앱이 not running상태일 때, 받은 푸쉬를 처리하는 메소드
     - parameter launchOptions : 앱 실행시 launchOptions에 푸쉬정보가 있는지 확인한 뒤, 있으면 푸쉬 처리를 하고 없다면 메소드 종료
     */
    func handleRemoteNotification(application: UIApplication, withLaunchingOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let notification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] else { return }
        appStartedWithNotification = true
        
        DispatchQueue.main.async { [weak self] in
            self?.didReceiveRemoteNotification(application: application, userInfo: notification)
        }
    }
    
    /**
     AppBadgeCount를 조절한다.
     */
    func setAppBadgeCount(count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = max(count, 0)
    }
    
    // MARK: - 디바이스 토큰 셋팅
    
    private func requestBindDeviceToken(token: String) {
        networkModel.requestBindDevice(token: token, success: {
            // 디바이스 토큰 등록 성공
            debugLog("[Push] device bind success.\ntoken: \(token)")
        }, failure: { error in
            warningLog("[Push] Failed to bind device and token value.\ntoken: \(token)\nerror: \(error.localizedDescription)")
        })
    }
    
    func requestUnbindDeviceToken(finally: (() -> Void)?) {
        guard let deviceToken = deviceTokenSubject.value ?? fetchLastDeviceToken() else {
            finally?()
            return
        }
        
        networkModel.requestUnbindDevice(token: deviceToken, success: {
            // 디바이스 토큰 해제 성공
            finally?()
        }) { error in
            warningLog("[Push] Failed to unbind device and token value.\ntoken value: \(deviceToken)\nerror: \(String(describing: error?.localizedDescription))\nNotificationAllowed: \(UIApplication.shared.isRegisteredForRemoteNotifications)")
            finally?()
        }
    }
    
    func requestUnbindDeviceTokenAsync() async {
        await withCheckedContinuation { [weak self] continuation in
            self?.requestUnbindDeviceToken(finally: {
                continuation.resume()
            })
        }
    }
}

// MARK: - 푸시 알림 처리

extension NotificationManager {
    private enum UserInfoKey: String {
        case pushType
        case linkUrl
        case notificationId
    }
    
    func createUserInfo(notificationType: NotificationType, linkUrl: String?, notificationId: String?) -> [AnyHashable: Any] {
        var userInfo: [AnyHashable: Any] = [
            UserInfoKey.pushType.rawValue: notificationType.rawValue
        ]
        
        if let linkUrl {
            userInfo[UserInfoKey.linkUrl.rawValue] = linkUrl
        }
        
        if let notificationId {
            userInfo[UserInfoKey.notificationId.rawValue] = notificationId
        }
        
        return userInfo
    }
    
    /// 푸시 알림 처리와 알림 읽음율 측정을 동시에 수행
    func parseUserInfoThenReadNotification(_ userInfo: [AnyHashable: Any]) {
        // 푸시 알림 처리
        parseUserInfo(userInfo)
    }
    
    /// 푸시알림 처리
    /// - 안드로이드와 동일하게 동작하도록 스펙 정리되었습니다.
    ///   - Ref. https://oss.navercorp.com/GP/app-issue/issues/4469#issuecomment-13848831
    /// - Remark: 푸시알림 테스트 방법 참고. https://oss.navercorp.com/GP/studioapp-ios/wiki/%ED%91%B8%EC%8B%9C%EC%95%8C%EB%A6%BC-%ED%85%8C%EC%8A%A4%ED%8A%B8
    private func parseUserInfo(_ userInfo: [AnyHashable: Any]) {
        debugLog("[Push] userInfo = \(userInfo.unicodeDecoded)")
        
        infoLog("[Push] 푸시 알림 처리.\n\(userInfo.unicodeDecoded)")
        
        // pushType 에 관계없이 linkUrl 처리.
        if let linkURL = userInfo[UserInfoKey.linkUrl.rawValue] as? String {
            let isFailedToParseLinkURL = parseLinkURL(linkURL) == false
            if isFailedToParseLinkURL {
                warningLog("[Push] 페이로드 정보 부족하여 랜딩페이지로 이동 실패.\n\(userInfo.unicodeDecoded)")
            }
        } else {
            warningLog("[Push] 푸시 기본 동작에 필요한 linkUrl 이 없습니다.\(userInfo.unicodeDecoded)")
        }
    }
    
    /// 푸시 알림 UserInfo.linkUrl 에 대한 처리
    @discardableResult
    private func parseLinkURL(_ linkURL: String?) -> Bool { // TODO: 추후 구현 예정
        return false
//        guard let linkURL else {
//            return false
//        }
//        
//        if let url = linkURL.urlValidated.url, url.isCustomScheme == true {
//            infoLog("[Push] 스키마 처리 완료. url = \(url)")
//            
//            SchemeManager.shared.executeScheme(url: url)
//            
//            return true
//        } else if let webURL = linkURL.webURL {
//            infoLog("[Push][Live/Noti] 푸시알림 조회. url = \(linkURL)")
//            
//            // 인앱브라우저에서 라이브/숏클립 native viewer로 진입하는 케이스 대응을 위해 navigation controller를 달아준다.
//            let targetVC: UIViewController = {
//                if let nc = InappBrowser.createNavigationControllerWithMobileWeb(url: webURL) {
//                    return nc
//                } else {
//                    errorLog("[Push] NavigationController를 가진 인앱브라우저 생성을 실패하여 단독 인앱브라우저 사용. url = \(linkURL)")
//                    return InappBrowser(url: webURL)
//                }
//            }()
//            
//            navigate(to: targetVC)
//            
//            return true
//        } else {
//            return false
//        }
    }
    
    // 랜딩 타겟 화면이 현재 화면과 다르면 보여주기
    private func navigate(to landingPage: UIViewController) { // TODO: 추후 확인해볼 예정
//        let currentPage = (UIApplication.topMostNavigationController?.viewControllers.last)
//
//        DispatchQueue.main.async {
//            // 인앱브라우저나 NavigationController는 present, 그 외에는 push로 처리한다.
//            if landingPage is InappBrowser || landingPage is UINavigationController {
//                currentPage?.present(landingPage, animated: true, completion: nil)
//            } else {
//                UIApplication.exposeViewController(landingPage)
//            }
//        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer { completionHandler() }
        
        let userInfo = response.notification.request.content.userInfo
        
        parseUserInfoThenReadNotification(userInfo)
        
        if let aps = userInfo["aps"] as? [String: Any],
            let count = aps["badge"] as? Int {
            setAppBadgeCount(count: count - 1)
        }
    }
}

extension NotificationManager {
    private var lastDeviceTokenKey: String { "lastDeviceToken_key" }
    
    /// bind에 사용했던 마지막 deviceToken 값을 리턴한다.
    /// - Remark: 백업해둔 토큰 값은 1회성으로만 사용. 값을 리턴 후 백업해둔 토큰값은 제거한다.
    private func fetchLastDeviceToken() -> String? {
        defer { backup(deviceToken: nil) }
        return UserDefaults.standard.string(forKey: lastDeviceTokenKey)
    }
    
    private func backup(deviceToken: String?) {
        UserDefaults.standard.set(deviceToken, forKey: lastDeviceTokenKey)
    }
}
