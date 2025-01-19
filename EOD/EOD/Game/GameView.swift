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
            Button(action: {
#if !PREVIEW
                GameManager.shared.launchUnity()
#endif
            }, label: {
                Text("게임시작")
                    .foregroundColor(.black)
            })
            
//            Text("Highest Score: \(gameDataViewModel.score)")
//            Text("Coin Count: \(gameDataViewModel.coinCount)")
        }
        .onAppear {
//            gameDataViewModel.sendHighScoreToUnity()
        }
    }
}

#Preview {
    GameView()
}
