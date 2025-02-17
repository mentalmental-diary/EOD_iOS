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
                }
            }
        }
    }
}

#Preview {
    GameView()
}

