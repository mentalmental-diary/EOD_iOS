//
//  GameDataViewMOdel.swift
//  EOD
//
//  Created by JooYoung Kim on 11/10/24.
//

import SwiftUI
import Combine

class GameDataViewModel: ObservableObject {
    @Published var score: Int = 0 {
        didSet {
            debugLog("게임 스코어? : \(score)")
        }
    }
    @Published var coinCount: Int = 0 {
        didSet {
            debugLog("코인? : \(coinCount)")
        }
    }
    private var gameSessionID: Int = 0 // `n`에 해당하는 값
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNotificationObserver()
    }
    
    private func setupNotificationObserver() {
        // 모든 알림을 감지하여 동적으로 처리
        NotificationCenter.default.publisher(for: Notification.Name("UnityMessage"))
            .compactMap { $0.userInfo?["message"] as? String }
            .sink { [weak self] message in
                self?.processUnityMessage(message)
            }
            .store(in: &cancellables)
    }
    
    private func processUnityMessage(_ message: String) { // TODO: 데이터 주고받은거 파싱하는거 나중에 확인해야할듯
        debugLog("Received message from Unity: \(message)") // 모든 메시지를 로그로 출력
        
        if message.hasPrefix("Game1_Score_") {
            debugLog("여기에 뭔가 정보가 들어오니? message: \(message)")
            if let score = Int(message.replacingOccurrences(of: "Game1_Score_", with: "")) {
                debugLog("여기에 뭔가 정보가 들어오니? score: \(score)")
                self.score = score
                UserDefaults.standard.set(score, forKey: "Game1_HighScore_\(self.gameSessionID)")
            }
        } else if message.hasPrefix("Game1_Coin_") {
            print("여기에 뭔가 정보가 들어오니? message: \(message)")
            if let coinCount = Int(message.replacingOccurrences(of: "Game1_Coin_", with: "")) {
                print("여기에 뭔가 정보가 들어오니? coinCount: \(coinCount)")
                self.coinCount = coinCount
                UserDefaults.standard.set(coinCount, forKey: "Game1_Coin_\(self.gameSessionID)")
            }
        }
    }

    func sendHighScoreToUnity() {
        let highScore = UserDefaults.standard.integer(forKey: "Game1_HighScore")
        let highScorePacket = "Game1_HighScore_\(highScore)"
        
        NotificationCenter.default.post(name: Notification.Name("SendHighScoreToUnity"), object: nil, userInfo: ["highScorePacket": highScorePacket])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
