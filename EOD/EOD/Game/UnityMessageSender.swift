//
//  UnityMessageSender.swift
//  EOD
//
//  Created by JooYoung Kim on 1/19/25.
//

import Foundation

class UnityMessageSender {
    static let shared = UnityMessageSender()

    private init() {}

    /// Unity로 메시지를 보냅니다.
    /// - Parameters:
    ///   - gameObject: Unity 오브젝트 이름
    ///   - methodName: Unity 메서드 이름
    ///   - message: Unity로 전달할 메시지
    func sendMessageToUnity(gameObject: String, methodName: String, message: String) {
        NotificationCenter.default.post(
            name: Notification.Name("SendMessageToUnity"),
            object: nil,
            userInfo: [
                "gameObject": gameObject,
                "methodName": methodName,
                "message": message
            ]
        )
    }
}
