//
//  LoginBootModule.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation
import UIKit
#if !PREVIEW
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin
#endif
private let kakaoNativeKey = "4a13f75194f630219ec0382991a34f1b"

class LoginBootModule: BootLoaderProtocol {
    static func loadModule() {
#if !PREVIEW
        kakaoInit()
        LoginManager.naverConfigure()
#endif
    }
#if !PREVIEW
    private class func kakaoInit() {
        debugLog("카카오 네이티브키 등록 된건가? key: \(kakaoNativeKey)")
        KakaoSDK.initSDK(appKey: kakaoNativeKey)
    }
#endif
}
