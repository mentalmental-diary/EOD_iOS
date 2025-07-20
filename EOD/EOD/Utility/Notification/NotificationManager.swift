//
//  NotificationManager.swift
//  EOD
//
//  Created by JooYoung Kim on 2/16/25.
//

import UIKit
import UserNotifications
import Combine

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private let deviceTokenSubject = CurrentValueSubject<String?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    private let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        bind()
        center.delegate = self
    }
    
    // MARK: - 권한 요청
    func registerNotificationIfNeeded(completion: ((Bool) -> Void)? = nil) {
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if let error = error {
                errorLog("[Push] 권한 요청 실패: \(error.localizedDescription)")
                completion?(false)
                return
            }
            
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion?(granted)
            }
        }
    }
    
    // MARK: - 디바이스 토큰 처리
    func didRegisterForRemoteNotification(tokenData: Data) {
        let token = tokenData.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        infoLog("[Push] APNs deviceToken: \(token)")
        deviceTokenSubject.send(token)
    }
    
    private func bind() {
        deviceTokenSubject
            .dropFirst()
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] token in
                self?.backup(token: token)
                self?.requestBindDeviceToken(token: token)
            }
            .store(in: &cancellables)
    }
    
    private func backup(token: String?) {
        UserDefaults.standard.set(token, forKey: "lastDeviceToken_key")
    }

    private func requestBindDeviceToken(token: String) {
        // 기존 FCM 연동 로직 유지
        NotificationNetworkModel().requestBindDevice(
            token: token,
            success: {
                debugLog("[Push] 디바이스 토큰 바인딩 성공")
            },
            failure: { error in
                warningLog("[Push] 토큰 바인딩 실패: \(error.localizedDescription)")
            }
        )
    }
    
    // MARK: - 로컬 알림 등록
    func scheduleDailyLocalNotification(id: String, title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                errorLog("[Push] 로컬 알림 등록 실패: \(error.localizedDescription)")
            } else {
                debugLog("[Push] 로컬 알림 등록 완료: \(id)")
            }
        }
    }

    func removeLocalNotification(id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    func removeAllLocalNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        parseUserInfoThenReadNotification(userInfo)
        completionHandler()
    }

    private func parseUserInfoThenReadNotification(_ userInfo: [AnyHashable: Any]) {
        // 필요한 경우: 딥링크 또는 통계 추적
        debugLog("[Push] 로컬 알림 수신: \(userInfo)")
    }
}
