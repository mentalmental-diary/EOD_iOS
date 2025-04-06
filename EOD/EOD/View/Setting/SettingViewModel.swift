//
//  SettingViewModel.swift
//  EOD
//
//  Created by JooYoung Kim on 4/5/25.
//

import Combine
import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var toastManager = ToastManager.shared
    
    // MARK: - alarm
    
    @Published var diaryNotificationEnabled: Bool = false { // 일기 쓰기 알림 설정 여부
        didSet {
            guard oldValue != diaryNotificationEnabled else { return }
            
            UserDefaults.standard.set(diaryNotificationEnabled, forKey: "diaryNotificationEnabled")
            
            self.toastManager.showToast(message: "알림 설정을 저장했어요.")
        }
    }
    
    @Published var gameNotificationEnabled: Bool = false { // 게임 알림 설정 여부
        didSet {
            guard oldValue != gameNotificationEnabled else { return }
            
            UserDefaults.standard.set(gameNotificationEnabled, forKey: "gameNotificationEnabled")
            
            self.toastManager.showToast(message: "알림 설정을 저장했어요.")
        }
    }
    
    @Published var marketingNotificationEnabled: Bool = false { // 마케팅 알림 설정 여부
        didSet {
            guard oldValue != marketingNotificationEnabled else { return }
            
            UserDefaults.standard.set(marketingNotificationEnabled, forKey: "marketingNotificationEnabled")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            let dateString = formatter.string(from: Date())
            
            if marketingNotificationEnabled {
                self.toastManager.showToast(message: "마케팅 정보 수신에 동의했어요. \n(동의일: \(dateString)")
            } else {
                self.toastManager.showToast(message: "마케팅 정보 수신에 동의를 철회했어요. \n(철회일: \(dateString)")
            }
        }
    }
    
    @Published var diaryNotificationTime: Date? {
        didSet {
            guard oldValue != diaryNotificationTime else { return }
            
            UserDefaults.standard.set(diaryNotificationTime, forKey: "diaryNotificationTime")
        }
    }
    
    @Published var gameNotificationTime: Date? {
        didSet {
            guard oldValue != gameNotificationTime else { return }
            
            UserDefaults.standard.set(gameNotificationTime, forKey: "gameNotificationTime")
        }
    }
    
    @Published var lockEnable: Bool = false { // 앱 잠금 여부
        didSet {
            guard oldValue != lockEnable else { return }
            
            UserDefaults.standard.set(lockEnable, forKey: "lockEnable")
            
            if lockEnable {
                visiblePwSettingView = true
            }
        }
    }
    
    @Published var visiblePwSettingView: Bool = false
    
    @Published var appPassWord: [Int] = []
    
    init() {
        diaryNotificationEnabled = UserDefaults.standard.bool(forKey: "diaryNotificationEnabled")
        gameNotificationEnabled = UserDefaults.standard.bool(forKey: "gameNotificationEnabled")
        marketingNotificationEnabled = UserDefaults.standard.bool(forKey: "marketingNotificationEnabled")
        
        if let diaryNotificationTime = UserDefaults.standard.object(forKey: "diaryNotificationTime") as? Date {
            self.diaryNotificationTime = diaryNotificationTime
        } else {
            self.diaryNotificationTime = Calendar.current.date(from: DateComponents(hour: 22, minute: 0))
        }
        
        if let gameNotificationTime = UserDefaults.standard.object(forKey: "gameNotificationTime") as? Date {
            self.gameNotificationTime = gameNotificationTime
        } else {
            self.gameNotificationTime = Calendar.current.date(from: DateComponents(hour: 24, minute: 0))
        }
        
        lockEnable = UserDefaults.standard.bool(forKey: "lockEnable")
    }
}

extension SettingViewModel {
    func addPassWord(number: Int) {
        guard appPassWord.count < 4 else { return }
        appPassWord.append(number)
        
        if appPassWord.count == 4 {
            visiblePwSettingView = false
        }
    }
    
    func removePassWord() {
        if !appPassWord.isEmpty {
            appPassWord.removeLast()
        }
    }
}
