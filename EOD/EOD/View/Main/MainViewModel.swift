//
//  MainViewModel.swift
//  EOD
//
//  Created by Joo Young Kim on 2023/09/23.
//

import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var isLogin: Bool = false
    @Published var currentTab: Tab = .Home
    @Published var confirmTerms: Bool = false
    @Published var inputNickname: String = ""
    
    @Published var toastManager = ToastManager.shared
    
    @Published var initScreen: Bool = true // 초기 웰컴 화면
    
    @Published var showUserInfoSetView: Bool = false
    
    @Published var showStartAlert: Bool = false // 닉네임 설정 후 최초 진입시에만 노출
    
    @Published var naverLoginError: Error? = nil
    
    var currentUserNickname: String = ""
    
    private var cancellables = Set<AnyCancellable>() // Combine 구독 관리
    
    let termsURL: String = "https://maple-drive-c5a.notion.site/25-04-01-1a32d71232c680eea608c75c01f9a06a?pvs=4"
    let personalInfomationURL: String = "https://maple-drive-c5a.notion.site/1a32d71232c680bd8e58e12ade5026cd?pvs=4"
    
    let onboardingItems: [OnboardingItem] = {
        let items = [
            OnboardingItem(imageName: "onBoardingImage_1", title: "노른자와 함께 \n나의 하루를 순간 포착", description: "나만의 귀여운 노른자에게 \n생각, 감정, 일상을 공유해주세요."),
            OnboardingItem(imageName: "onBoardingImage_2", title: "일기 쓰고 게임했더니 \n보상이 와르르!", description: "숨은 업적을 달성하고, 게임하다 보면 \n상품을 획득할 수 있어요."),
            OnboardingItem(imageName: "onBoardingImage_3", title: "내 일기는 내 맘대로 \n다채롭게 꾸며요", description: "획득한 보상으로 나만의 일기장을 만들어 보세요! \n노른자도, 노른자 방도 꾸며줄 수 있어요.")
        ]
        
        return items
    }()
    
    private var networkModel: UserNetworkModel = UserNetworkModel()
    
    init() {
        isLogin = LoginManager.shared.isLogin ?? false
        
        // LoginManager의 loginResult를 구독하여 처리
        self.naverLoginAction()
        self.bindDetectToken()
    }
    
}

/// Func
extension MainViewModel {
    func bindDetectToken() {
        NotificationCenter.default.publisher(for: .tokenExpiredNotification)
            .sink { [weak self] _ in
                self?.logoutAction()
            }
            .store(in: &cancellables)
    }
    
    func logoutAction() {
        networkModel.postLogout { [weak self] result in
            // API 성공/실패 여부와 관계없이 로컬 데이터는 처리
            DispatchQueue.main.async {
                // ✅ 세션 데이터만 삭제 (유저 데이터는 유지)
                UserDefaultsManager.shared.clearSessionData()
                
                // ViewModel 상태 초기화
                self?.resetViewModelState()
                
                // 예약된 알림은 유지 (유저가 다시 로그인하면 복구)
                
                switch result {
                case .success:
                    debugLog("✅ 로그아웃 성공 - 세션만 삭제, 유저 데이터는 유지")
                case .failure(let error):
                    errorLog("🔴 로그아웃 API 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 로그아웃 시 ViewModel 상태 초기화
    private func resetViewModelState() {
        self.isLogin = false
        self.currentTab = .Home
        self.inputNickname = ""
        self.currentUserNickname = ""
        self.confirmTerms = false
        self.showUserInfoSetView = false
        self.showStartAlert = false
        self.naverLoginError = nil
        
        debugLog("✅ 로그아웃: ViewModel 상태 초기화 완료")
    }
    
    func kakaoLoginAction() {
#if !PREVIEW
        LoginManager.shared.getKakaoOathToken(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.networkModel.fetchLogin(Authorization: token, type: .kakao, completion: { result in
                    guard let error = result.error else {
                        self.checkNicknameAndAccessLogin()
                        return
                    }
                    self.toastManager.showToast(message: "카카오 로그인 연동 실패했습니다.")
                    errorLog("🔴 카카오 로그인 연동 후 서버 연동 실패: \(error.localizedDescription)")
                })
            case .failure(let error):
                errorLog("🔴 카카오 로그인 연동 실패: \(error.localizedDescription)")
            }
        })
#endif
    }
    
    func naverLoginAction() {
        LoginManager.shared.$naverLoginResult
            .receive(on: DispatchQueue.main) // UI 업데이트는 메인 스레드에서 처리
            .sink { [weak self] result in
                guard let self = self, let result = result else { return }
                switch result {
                case .success(let accessToken):
                    self.networkModel.fetchLogin(Authorization: accessToken, type: .naver, completion: { result in
                        guard let error = result.error else {
                            self.checkNicknameAndAccessLogin()
                            return
                        }
                        self.toastManager.showToast(message: "네아로 연동 실패했습니다.")
                        errorLog("🔴 네아로 연동 후 서버 연동 실패: \(error.localizedDescription)")
                    })
                case .failure(let error):
                    self.naverLoginError = error
                    errorLog("🔴 네이버 로그인 연동 실패: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    func appleLoginAction(token: String) {
        self.networkModel.fetchLogin(Authorization: token, type: .apple, completion: { result in
            guard let error = result.error else {
                self.checkNicknameAndAccessLogin()
                return
            }
            self.toastManager.showToast(message: "애플 로그인 연동 실패했습니다.")
            errorLog("🔴 애플 연동 후 서버 연동 실패: \(error.localizedDescription)")
        })
    }
    
    private func setUserInfo(accessToken: String) {
        UserDefaultsManager.shared.accessToken = accessToken
        UserDefaultsManager.shared.isLogin = true
    }
}

// MARK: - Notification
extension MainViewModel {
    func registerNotification() {
        NotificationManager.shared.registerNotificationIfNeeded { isAccept in
            guard isAccept else { return }
            debugLog("알림 수신 동의?")
        }
    }
}

// MARK: - Nickname (User Info)
extension MainViewModel {
    /// 현재 유저가 닉네임이 설정되있는지 확인 후 닉네임 화면 진입 또는 메인화면 진입
    func checkNicknameAndAccessLogin() {
        // 1. 먼저 userNo 조회
        networkModel.fetchUserNo { [weak self] userNoResult in
            guard let self = self else { return }
            
            switch userNoResult {
            case .success(let userNo):
                // userNo 저장
                UserDefaultsManager.shared.currentUserNo = userNo
                debugLog("✅ userNo 저장 완료: \(userNo)")
                
                // 기존 데이터 마이그레이션 (기존 사용자 대응)
                UserDefaultsManager.shared.migrateOldDataIfNeeded(userNo: userNo)
                
                // 2. 닉네임 체크
                self.networkModel.checkUserNickname(completion: { [weak self] result in
                    switch result {
                    case .success(let check):
                        if check { // 이미 닉네임이 설정되있으면 홈화면으로 진입 -> 로그인 성공
                            self?.isLogin = true
                        } else {
                            self?.showUserInfoSetView = true
                        }
                    case .failure(let error):
                        self?.toastManager.showToast(message: "닉네임 여부 판단 실패")
                        errorLog("🔴 닉네임 존재 여부 판단 API 실패: \(error.localizedDescription)")
                    }
                })
                
            case .failure(let error):
                errorLog("🔴 userNo 조회 실패: \(error.localizedDescription)")
                // userNo 조회 실패해도 로그인은 진행 (임시 방편)
                self.networkModel.checkUserNickname(completion: { [weak self] result in
                    switch result {
                    case .success(let check):
                        if check {
                            self?.isLogin = true
                        } else {
                            self?.showUserInfoSetView = true
                        }
                    case .failure(let error):
                        self?.toastManager.showToast(message: "닉네임 여부 판단 실패")
                        errorLog("🔴 닉네임 존재 여부 판단 API 실패: \(error.localizedDescription)")
                    }
                })
            }
        }
    }
    
    /// 닉네임 설정
    func setNickname(completion: (() -> Void)? = nil) {
        guard !self.inputNickname.isEmpty else { return }
        networkModel.setUserNickname(nickName: inputNickname, completion: { [weak self] result in
            switch result {
            case .success: // 닉네임 설정 성공
                DispatchQueue.main.async {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if self?.isLogin == false {
                        self?.isLogin = true
                        self?.showUserInfoSetView = false
                        self?.showStartAlert = true
                    }
                    completion?()
                }
            case .failure(let error):
                self?.toastManager.showToast(message: "닉네임 설정 실패")
                errorLog("🔴 닉네임 설정 API 실패: \(error.localizedDescription)")
            }
        })
    }
    
    func getNickname() {
        networkModel.getUserNickname { [weak self] result in
            switch result {
            case .success(let nickname):
                debugLog("닉네임 조회 성공: 서버에서 내려온 닉네임 : \(nickname)")
                self?.currentUserNickname = nickname ?? ""
                self?.inputNickname = nickname ?? ""
            case .failure(let error):
                self?.toastManager.showToast(message: "닉네임 조회 실패")
                errorLog("🔴 닉네임 조회 API 실패: \(error.localizedDescription)")
            }
        }
    }
    
    var changeNickname: Bool { return inputNickname != currentUserNickname }
}

// MARK: - 회원탈퇴
extension MainViewModel {
    func userLeaveAction() {
        // 탈퇴할 유저의 userNo 보관
        guard let userNo = UserDefaultsManager.shared.currentUserNo else {
            toastManager.showToast(message: "사용자 정보를 찾을 수 없습니다")
            errorLog("🔴 회원 탈퇴 실패: userNo가 없음")
            return
        }
        
        networkModel.postLeaveUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    debugLog("✅ 회원 탈퇴 API 성공")
                    
                    // 1. 해당 유저의 모든 데이터 삭제
                    UserDefaultsManager.shared.clearUserData(userNo: userNo)
                    
                    // 2. 세션 데이터 삭제
                    UserDefaultsManager.shared.clearSessionData()
                    
                    // 3. 예약된 알림 삭제 (탈퇴한 유저이므로)
                    NotificationManager.shared.removeAllLocalNotifications()
                    
                    // 4. ViewModel 상태 초기화
                    self?.resetViewModelState()
                    
                    debugLog("✅ 회원 탈퇴 완료: userNo=\(userNo)의 모든 데이터 삭제")
                    
                case .failure(let error):
                    self?.toastManager.showToast(message: "회원 탈퇴 실패")
                    errorLog("🔴 회원 탈퇴 API 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - TAB ITEM CASE
enum Tab: String {
    case Home = "home"
    case Calender = "calender"
    case Game = "game"
    case Setting = "setting"
    
    var title: String {
        switch self {
        case .Home: return "홈"
        case .Calender: return "캘린더"
        case .Game: return "게임"
        case .Setting: return "설정"
        }
    }
    
    var iconName: String {
        switch self {
        case .Home: return "icon_home"
        case .Calender: return "icon_calander"
        case .Game: return "icon_game"
        case .Setting: return "icon_setting"
        }
    }
}

/// Swipe Back
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

// MARK: - OnboardingItem

struct OnboardingItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}
