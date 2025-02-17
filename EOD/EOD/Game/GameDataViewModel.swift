//
//  GameDataViewMOdel.swift
//  EOD
//
//  Created by JooYoung Kim on 11/10/24.
//

import SwiftUI
import Combine

class GameDataViewModel: ObservableObject {
    // 게임별 데이터를 저장
    @Published private(set) var games: [GameType: GameData] = [:]
    
    // 현재 진입한 게임
    @Published var currentGame: GameType? {
        didSet {
            if let game = currentGame {
                debugLog("현재 진입한 게임: \(game.rawValue)")
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupGames()
        setupNotificationObserver()
    }
    
    
    // 초기화 시 모든 게임 데이터 설정
    private func setupGames() {
        GameType.allCases.forEach { game in
            games[game] = GameData(game: game)
        }
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
    
    func updateScore(for game: GameType, score: Int) {
        games[game]?.score = score
    }

    func updateCoinCount(for game: GameType, coinCount: Int) {
        games[game]?.coinCount = coinCount
    }

    func getScore(for game: GameType) -> Int {
        return games[game]?.score ?? 0
    }

    func getCoinCount(for game: GameType) -> Int {
        return games[game]?.coinCount ?? 0
    }
    
    private func processUnityMessage(_ message: String) {
        guard let currentGame = currentGame else {
            debugLog("현재 진입한 게임이 설정되지 않았습니다.")
            return
        }
        
        if message.hasPrefix("\(currentGame.rawValue)_Score_") {
            if let score = Int(message.replacingOccurrences(of: "\(currentGame.rawValue)_Score_", with: "")) {
                updateScore(for: currentGame, score: score)
                debugLog("\(currentGame.rawValue)의 새로운 점수: \(score)")
            }
        } else if message.hasPrefix("\(currentGame.rawValue)_Coin_") {
            if let coinCount = Int(message.replacingOccurrences(of: "\(currentGame.rawValue)_Coin_", with: "")) {
                updateCoinCount(for: currentGame, coinCount: coinCount)
                debugLog("\(currentGame.rawValue)의 새로운 코인 수: \(coinCount)")
            }
        } else if message.hasPrefix("EndGame") {
            GameManager.shared.finishUnity()
        } else {
            debugLog("메시지가 현재 게임과 일치하지 않습니다: \(message)")
        }
    }
    
    func sendGameStartMessage(for game: GameType) {
        currentGame = game
        let objectName = "RecieveData"
        let methodName = "ReceiveMessage"
        let message = game.openMessage
        UnityMessageSender.shared.sendMessageToUnity(
            gameObject: objectName,
            methodName: methodName,
            message: message
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

enum GameType: String, CaseIterable {
    case catchYolk = "CatchYolk"
    case runYolk = "RunYolk"
    case flyYolk = "FlyYolk"
    
    var openMessage: String {
        return "\(self.rawValue)_Open_TRUE"
    }
    
    var scoreKey: String {
        return "\(self.rawValue)_HighScore"
    }
    
    var coinKey: String {
        return "\(self.rawValue)_Coin"
    }
}

class GameData: ObservableObject {
    private let game: GameType
    
    @Published var score: Int {
        didSet {
            saveScore()
        }
    }
    
    @Published var coinCount: Int {
        didSet {
            saveCoinCount()
        }
    }
    
    init(game: GameType) {
        self.game = game
        self.score = UserDefaults.standard.integer(forKey: game.scoreKey)
        self.coinCount = UserDefaults.standard.integer(forKey: game.coinKey)
    }
    
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: game.scoreKey)
    }
    
    private func saveCoinCount() {
        UserDefaults.standard.set(coinCount, forKey: game.coinKey)
    }
}
