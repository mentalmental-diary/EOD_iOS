//
//  GameDataViewMOdel.swift
//  EOD
//
//  Created by JooYoung Kim on 11/10/24.
//

import SwiftUI
import Combine

class GameDataViewModel: ObservableObject {
    @Published private(set) var games: [GameData] = []
    
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
        games = GameType.allCases.map { GameData(game: $0) }
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
        if let index = games.firstIndex(where: { $0.game == game }) {
            var newGameData = games[index]
            newGameData.updateScore(score) // ✅ UserDefaults에 저장 포함
            games[index] = newGameData // ✅ SwiftUI가 감지할 수 있도록 배열 요소 교체
        }
    }
    
    func updateCoinCount(for game: GameType, coinCount: Int) {
        if let index = games.firstIndex(where: { $0.game == game }) {
            var newGameData = games[index]
            newGameData.updateCoinCount(coinCount) // ✅ UserDefaults에 저장 포함
            games[index] = newGameData // ✅ SwiftUI가 감지할 수 있도록 배열 요소 교체
        }
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
#if !PREVIEW
            GameManager.shared.finishUnity()
#endif
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

struct GameData: Identifiable {
    let id = UUID()
    let game: GameType
    var score: Int
    var coinCount: Int
    
    init(game: GameType) {
        self.game = game
        self.score = UserDefaults.standard.integer(forKey: game.scoreKey)
        self.coinCount = UserDefaults.standard.integer(forKey: game.coinKey)
    }
    
    // ✅ 점수 저장
    mutating func updateScore(_ newScore: Int) {
        self.score = newScore
        saveScore()
    }
    
    // ✅ 코인 저장
    mutating func updateCoinCount(_ newCoinCount: Int) {
        self.coinCount = newCoinCount
        saveCoinCount()
    }
    
    // ✅ UserDefaults에 점수 저장
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: game.scoreKey)
    }
    
    // ✅ UserDefaults에 코인 저장
    private func saveCoinCount() {
        UserDefaults.standard.set(coinCount, forKey: game.coinKey)
    }
}
