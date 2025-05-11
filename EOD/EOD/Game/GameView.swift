//
//  GameView.swift
//  EOD
//
//  Created by JooYoung Kim on 8/24/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameDataViewModel: GameDataViewModel = GameDataViewModel()
    
    var body: some View {
        VStack {
            ForEach(gameDataViewModel.games) { gameData in
                VStack {
                    Button("\(gameData.game.rawValue) 게임 시작") {
                        guard let accessData = gameDataViewModel.dailyLimits[gameData.game],
                              accessData.accessCount < 3 else {
                            print("오늘은 진입 불가")
                            return
                        }
#if !PREVIEW
                        GameManager.shared.launchUnity()
                        gameDataViewModel.sendGameStartMessage(for: gameData.game)
#endif
                    }
                    .padding()
                    
                    // ✅ @Published 값을 직접 바인딩하여 변경 즉시 UI 업데이트
                    Text("\(gameData.game.rawValue) 점수: \(gameData.score), 코인: \(gameData.coinCount)")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    
                    if let accessData = gameDataViewModel.dailyLimits[gameData.game] {
                        if accessData.accessCount >= 3 {
                            Text("\(gameData.game) 금일 진입 횟수 종료")
                                .foregroundColor(.red)
                                .font(.caption)
                        } else {
                            Text("\(gameData.game) 금일 진입 가능 횟수: \(3 - accessData.accessCount)회")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GameView()
}

