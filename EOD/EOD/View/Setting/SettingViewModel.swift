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
            guard oldValue != diaryNotificationEnabled, checkInit == true else { return }
            
            UserDefaults.standard.set(diaryNotificationEnabled, forKey: "diaryNotificationEnabled")
            
            self.toastManager.showToast(message: "알림 설정을 저장했어요.")
        }
    }
    
    @Published var gameNotificationEnabled: Bool = false { // 게임 알림 설정 여부
        didSet {
            guard oldValue != gameNotificationEnabled, checkInit == true else { return }
            
            UserDefaults.standard.set(gameNotificationEnabled, forKey: "gameNotificationEnabled")
            
            self.toastManager.showToast(message: "알림 설정을 저장했어요.")
        }
    }
    
    @Published var marketingNotificationEnabled: Bool = false { // 마케팅 알림 설정 여부
        didSet {
            guard oldValue != marketingNotificationEnabled, checkInit == true else { return }
            
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
            guard oldValue != lockEnable, checkInit == true else { return }
            
            UserDefaults.standard.set(lockEnable, forKey: "lockEnable")
            
            if lockEnable {
                visiblePwSettingView = true
                isSettingNewPassword = true // 최초 설정 시
            } else {
                clearStoredPassword()
            }
        }
    }
    
    @Published var visiblePwSettingView: Bool = false
    @Published var changePwSettingView: Bool = false
    
    @Published var appPassWord: [Int] = []
    
    @Published var confirmPassword: [Int] = []  // 이중 확인용
    @Published var inputViewTitle: String = ""
    @Published var visibleWarningMessage: Bool = false
    private var checkInit: Bool = false
    
    // 상태 플래그
    var isSettingNewPassword: Bool = false
    private var firstInputPassword: [Int]? = nil
    
    // 상태 플래그
    private var isChangingPassword: Bool = false
    private var isCheckingCurrentPassword: Bool = false
    private var isConfirmingNewPassword: Bool = false
    
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
        
        checkInit = true
        self.inputViewTitle = initTitle
    }
}

extension SettingViewModel {
    private var initTitle: String { return "비밀번호를 입력해주세요!" }
}

extension SettingViewModel {
    func addPassWord(number: Int) {
        guard appPassWord.count < 4 else { return }
        appPassWord.append(number)
        
        if appPassWord.count == 4 {
            if isSettingNewPassword {
                handleNewPasswordSetup()
            }
            else if isChangingPassword && isCheckingCurrentPassword {
                validateCurrentPasswordForChange()
            }
            else if isChangingPassword && isConfirmingNewPassword {
                confirmNewPasswordForChange()
            }
            else if isChangingPassword {
                prepareNewPasswordForChange()
            }
            else {
                validateCurrentPassword() // 일반 잠금 해제용
            }
        }
    }
    
    func removePassWord() {
        if !appPassWord.isEmpty {
            appPassWord.removeLast()
        }
    }
    
    private func handleNewPasswordSetup() {
        if firstInputPassword == nil {
            // 첫 입력
            firstInputPassword = appPassWord
            appPassWord = []
            inputViewTitle = "다시 한 번 입력해주세요!"
            visibleWarningMessage = false
        } else {
            // 두 번째 입력
            if firstInputPassword == appPassWord {
                savePassword(appPassWord)
                toastManager.showToast(message: "비밀번호를 설정했어요.")
                visiblePwSettingView = false
                isSettingNewPassword = false
                inputViewTitle = initTitle
                visibleWarningMessage = false
            } else {
                inputViewTitle = "비밀번호를 다시 입력해주세요!"
                visibleWarningMessage = true
                firstInputPassword = nil
            }
            appPassWord = []
        }
    }
    
    private func validateCurrentPassword() {
        if appPassWord == (loadStoredPassword() ?? []) {
            visiblePwSettingView = false
            visibleWarningMessage = false
            visibleWarningMessage = false
            inputViewTitle = "비밀번호를 입력해주세요!"
        } else {
            inputViewTitle = "비밀번호를 다시 입력해주세요!"
            visibleWarningMessage = true
        }
        appPassWord = []
    }
    
    
    // 1️⃣ 기존 비밀번호 확인
    private func validateCurrentPasswordForChange() {
        if appPassWord == (loadStoredPassword() ?? []) {
            isCheckingCurrentPassword = false
            isConfirmingNewPassword = false
            visibleWarningMessage = false
            inputViewTitle = "변경할 비밀번호를 입력해주세요!"
        } else {
            inputViewTitle = "비밀번호를 다시 입력해주세요!"
            visibleWarningMessage = true
        }
        appPassWord = []
    }
    
    // 2️⃣ 새 비밀번호 첫 입력 완료 → 재확인 단계 준비
    private func prepareNewPasswordForChange() {
        firstInputPassword = appPassWord
        appPassWord = []
        isConfirmingNewPassword = true
        inputViewTitle = "다시 한 번 입력해주세요!"
        visibleWarningMessage = false
    }
    
    // 3️⃣ 새 비밀번호 재확인
    private func confirmNewPasswordForChange() {
        if firstInputPassword == appPassWord {
            savePassword(appPassWord)
            toastManager.showToast(message: "비밀번호가 변경됐어요.")
            resetPasswordInput()
            changePwSettingView = false
            visiblePwSettingView = false
            isChangingPassword = false
            visibleWarningMessage = false
            inputViewTitle = initTitle
        } else {
            inputViewTitle = "비밀번호를 다시 입력해주세요!"
            visibleWarningMessage = true
            appPassWord = []
            firstInputPassword = nil
            isConfirmingNewPassword = false
        }
    }
        
    private func clearStoredPassword() {
        appPassWord = []
        UserDefaults.standard.removeObject(forKey: "appPassword")
    }
    
    private func savePassword(_ password: [Int]) {
        let passwordString = password.map { String($0) }.joined()
        UserDefaults.standard.set(passwordString, forKey: "appPassword")
    }
    
    private func loadStoredPassword() -> [Int]? {
        guard let pwString = UserDefaults.standard.string(forKey: "appPassword") else { return nil }
        return pwString.compactMap { Int(String($0)) }
    }
    
    // 뒤로가기 시 입력값 초기화
    func resetPasswordInput() {
        appPassWord = []
        firstInputPassword = nil
        isCheckingCurrentPassword = false
        isConfirmingNewPassword = false
        isChangingPassword = false
        isSettingNewPassword = false
        inputViewTitle = initTitle
        visibleWarningMessage = false
        if lockEnable && loadStoredPassword() == nil { // 잠금 설정 최초 진입에서 뒤로가는 경우(기존에 저장된 내용이 없음)
            lockEnable = false
        }
    }
    
    func startPasswordChange() {
        isChangingPassword = true
        isCheckingCurrentPassword = true
        visiblePwSettingView = true
        visibleWarningMessage = false
        appPassWord = []
    }
}
