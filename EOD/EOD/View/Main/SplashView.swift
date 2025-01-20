//
//  SplashView.swift
//  EOD
//
//  Created by JooYoung Kim on 8/7/24.
//

import SwiftUI
import Lottie

struct SplashView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("노른자의 하루")
                .font(size: 32)
                .foregroundColor(UIColor.Yellow.yellow500.color)
            
            Spacer().frame(height: 35)
            
            LottieView(animation: .named("splash", bundle: Bundle.main))
                .configure({ lottieView in
                    lottieView.animationSpeed = 1.0
                    lottieView.loopMode = .loop
                })
                .playing()
                .frame(width: 150, height: 150)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UIColor.CommonBackground.background.color)
        
    }
}

#Preview {
    SplashView()
}
