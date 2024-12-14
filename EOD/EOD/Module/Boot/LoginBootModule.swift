//
//  LoginBootModule.swift
//  EOD
//
//  Created by USER on 2023/10/02.
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

private let kakaoNativeKey = "4a13f75194f630219ec0382991a34f1b"

class LoginBootModule: BootLoaderProtocol {
    static func loadModule() {
        KakaoSDK.initSDK(appKey:kakaoNativeKey)
    }
}
