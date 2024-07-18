//
//  LoadingView.swift
//  EOD
//
//  Created by JooYoung Kim on 7/12/24.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    public let named: String
    public let bundle: Bundle?
    public let loopMode: LottieLoopMode
    public let speed: CGFloat
    
    public init(named: String, bundle: Bundle?, loopMode: LottieLoopMode = .loop, speed: CGFloat = 1.0) {
        self.named = named
        self.bundle = bundle
        self.loopMode = loopMode
        self.speed = speed
    }
    
    public var body: some View {
        ZStack {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 251/255, green: 251/255, blue: 244/255, opacity: 0.8))
                .zIndex(-1)
            
            LottieView(animation: .named(named, bundle: bundle ?? .main))
                .configure({ lottieView in
                    lottieView.animationSpeed = speed
                    lottieView.loopMode = loopMode
                })
                .playing()
                .frame(width: 150, height: 150)
        }
    }
}

#Preview {
    LoadingView(named: "short-loading", bundle: Bundle.main)
}
