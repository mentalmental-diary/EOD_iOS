//
//  UIApplication+Extension.swift
//  EOD
//
//  Created by USER on 2023/10/01.
//

import Foundation
import UIKit

public extension UIApplication {
    
    static var isUnitTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    /// SwiftUI Preview 상황인지 판단한다.
    static var isPreview: Bool {
        #if RELEASE
        return false
        #else
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"]?.int == 1
        #endif
    }
    
    /// 기존의 `keyWindow` 대신 사용할 수 있는 property
    var firstKeyWindow: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first(where: { $0.isKeyWindow })
    }
    
    /// 기존의 `statusBarOrientation` 대신 사용할 수 있는 property
    var interfaceOrientation: UIInterfaceOrientation? {
        firstKeyWindow?.windowScene?.interfaceOrientation
    }
    
    static var rootViewController: UIViewController? {
        UIApplication.shared.firstKeyWindow?.rootViewController
    }
    
    /// 가장 top에 있는 viewController
    static var topMostController: UIViewController? {
        var presentedVC = UIApplication.rootViewController
        
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        return presentedVC
    }
    
    /// 가장 top에 있는 navigationController
    static var topMostNavigationController: UINavigationController? {
        var navigationController = UIApplication.topMostController
        
        while !(navigationController is UINavigationController) {
            navigationController = navigationController?.presentingViewController
            
            // 무한루프를 방지하기 위한 방어코드. 호출될 가능성은 없음
            if navigationController == nil {
                warningLog("There is no topMostNavigationController")
                return UIApplication.rootViewController as? UINavigationController
            }
        }
        
        if let tabbarController = (navigationController as? UINavigationController)?.viewControllers.first as? UITabBarController,
           let nc = tabbarController.viewControllers?[tabbarController.selectedIndex] as? UINavigationController {
            navigationController = nc
        }
        
        return navigationController as? UINavigationController
    }
    
    /// 현재 노출되고 있는 키보드를 닫아줌
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
