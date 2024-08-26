//
//  GameView.swift
//  EOD
//
//  Created by JooYoung Kim on 8/24/24.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        Button(action: {
            GameManager.shared.launchUnity()
        }, label: {
            Text("게임시작")
                .foregroundColor(.black)
        })
    }
}

#Preview {
    GameView()
}
