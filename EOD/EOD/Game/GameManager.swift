//
//  GameManager.swift
//  EOD
//
//  Created by JooYoung Kim on 8/26/24.
//

import UIKit

#if !PREVIEW
import UnityFramework

class GameManager {
    
    static let shared = GameManager()
    
    private let dataBundleId: String = "com.unity3d.framework"
    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"
    
    private var ufw: UnityFramework?
    
    private var previousWindow: UIWindow? // 기존 앱의 UIWindow 저장
    private var unityWindow: UIWindow? // Unity 실행을 위한 UIWindow

    private init() {}

    func launchUnity() {
        let isInitialized = self.ufw?.appController() != nil
        if isInitialized {
            self.ufw?.showUnityWindow()
        } else {
            guard let ufw = self.loadUnityFramework() else { return }
            self.ufw = ufw
            ufw.setDataBundleId(dataBundleId)
            
            // ✅ 기존 UIWindow 저장
            if let currentWindow = getCurrentWindow() {
                self.previousWindow = currentWindow
            }
            
            // ✅ Unity 실행 전 화면 클리어 (잔상 방지)
            clearUnityLayer()

            
            ufw.runEmbedded(
                withArgc: CommandLine.argc,
                argv: CommandLine.unsafeArgv,
                appLaunchOpts: nil
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                // ✅ Unity 실행을 위한 새로운 UIWindow 생성
                guard let unityRootVC = ufw.appController()?.rootViewController else {
                    print("🚨 Unity rootViewController를 가져올 수 없습니다.")
                    return
                }
                
                let newWindow = UIWindow(frame: UIScreen.main.bounds)
                newWindow.rootViewController = unityRootVC
                newWindow.windowLevel = .normal
                self.unityWindow = newWindow
            })
            
            
        }
    }

    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + frameworkPath
        guard let bundle = Bundle(path: bundlePath) else { return nil }

        if !bundle.isLoaded {
            bundle.load()
        }

        guard let ufw = bundle.principalClass?.getInstance() else { return nil }
        
        // UnityFramework의 appController가 설정되지 않았다면 설정
        if ufw.appController() == nil {
            ufw.setExecuteHeader(nil) // 헤더 설정 제거
        }
        
        return ufw
    }
    
    func finishUnity() {
        guard let ufw = self.ufw else { return }
        
        ufw.unloadApplication()
        self.ufw = nil
        
        // Unity 종료 후 SwiftUI에 알림 전송
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.restorePreviousWindow() // Unity가 만든 UIWindow 삭제
        }
    }
    
    // ✅ Unity가 실행한 UIWindow 제거 후 기존 UIWindow 복구
    private func restorePreviousWindow() {
        if let unityWin = self.unityWindow {
            unityWin.isHidden = true
            unityWin.removeFromSuperview()
            self.unityWindow = nil
        }
        
        if let previousWin = self.previousWindow {
            previousWin.makeKeyAndVisible()
            self.previousWindow = nil
        }
    }
    
    // ✅ Unity 실행 전 Layer 클리어 (잔상 방지)
    private func clearUnityLayer() {
        guard let unityAppController = ufw?.appController(),
              let layer = unityAppController.rootView?.layer as? CAMetalLayer,
              let drawable = layer.nextDrawable(),
              let buffer = MTLCreateSystemDefaultDevice()?.makeCommandQueue()?.makeCommandBuffer() else {
            return
        }
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].texture = drawable.texture
        descriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        
        if let encoder = buffer.makeRenderCommandEncoder(descriptor: descriptor) {
            encoder.label = "Unity Prestart Clear"
            encoder.endEncoding()
            buffer.present(drawable)
            buffer.commit()
            buffer.waitUntilCompleted()
        }
    }
    
    func getCurrentWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
}

#endif
