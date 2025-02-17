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
            Button("이불 덮어주기? 게임 시작") {
#if !PREVIEW
                GameManager.shared.launchUnity()
                gameDataViewModel.sendGameStartMessage(for: .catchYolk)
#endif
            }
            .padding()
            
            Text("1번 게임 점수: \(gameDataViewModel.getScore(for: .catchYolk)), 획득 코인 : \(gameDataViewModel.getCoinCount(for: .catchYolk))")
                .font(size: 16)
                .foregroundColor(.black)
            
            Button("노른자 날아댕김 게임 시작") {
#if !PREVIEW
                GameManager.shared.launchUnity()
                gameDataViewModel.sendGameStartMessage(for: .flyYolk)
#endif
            }
            .padding()
            
            Text("2번 게임 점수: \(gameDataViewModel.getScore(for: .flyYolk)), 획득 코인 : \(gameDataViewModel.getCoinCount(for: .flyYolk))")
                .font(size: 16)
                .foregroundColor(.black)
            
            Button("피하기 게임 시작") {
#if !PREVIEW
                GameManager.shared.launchUnity()
                gameDataViewModel.sendGameStartMessage(for: .runYolk)
#endif
            }
            .padding()
            
            Text("3번 게임 점수: \(gameDataViewModel.getScore(for: .runYolk)), 획득 코인 : \(gameDataViewModel.getCoinCount(for: .runYolk))")
                .font(size: 16)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    GameView()
}

