//
//  GameManager.swift
//  EOD
//
//  Created by JooYoung Kim on 8/26/24.
//

#if !PREVIEW
import UnityFramework

class GameManager {
    
    static let shared = GameManager()
    
    private let dataBundleId: String = "com.unity3d.framework"
    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"
    
    private var ufw: UnityFramework?
    
    private init() {}

    func launchUnity() {
        let isInitialized = self.ufw?.appController() != nil
        if isInitialized {
            self.ufw?.showUnityWindow()
        } else {
            guard let ufw = self.loadUnityFramework() else { return }
            self.ufw = ufw
            ufw.setDataBundleId(dataBundleId)
            ufw.runEmbedded(
                withArgc: CommandLine.argc,
                argv: CommandLine.unsafeArgv,
                appLaunchOpts: nil
            )
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
}

#endif
