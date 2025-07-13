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
    @Published var confirmEmail: Bool = false
    @Published var confirmTerms: Bool = false
    @Published var inputNickname: String = ""
    
    @Published var toastManager = ToastManager.shared
    
    @Published var initScreen: Bool = true // 초기 웰컴 화면
    
    @Published var showUserInfoSetView: Bool = false
    
    @Published var showStartAlert: Bool = false // 닉네임 설정 후 최초 진입시에만 노출
    
    var presentLoginView: Bool = false // 로그인뷰가 노출되어있는지 확인 -> 회원가입뷰에서 왔다갔다 하기 위해 // TODO: 삭제 예정
    var presentSignUpView: Bool = false // 회원가입뷰가 노출되어있는지 확인 -> 로그인뷰와 왔다갔다 하기 위해 // TODO: 삭제 예정
    
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
    }
    
}

/// Func
extension MainViewModel {
    func logoutAction() { // TODO: 로그아웃 로직 수정 -> API연결 필요
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "diaryNotificationEnabled")
        UserDefaults.standard.removeObject(forKey: "gameNotificationEnabled")
        UserDefaults.standard.removeObject(forKey: "marketingNotificationEnabled")
        UserDefaults.standard.removeObject(forKey: "diaryNotificationTime")
        UserDefaults.standard.removeObject(forKey: "gameNotificationTime")
        self.isLogin = false
        self.currentTab = .Home
        self.inputNickname = ""
        self.currentUserNickname = ""
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
    
    func testLogin() {
        let randomId = UUID().uuidString
        networkModel.fetchSignUp(email: randomId, password: "1234", completion: { [weak self] result in
            guard let error = result.error else {
                self?.presentLoginView = false // 로그인 성공시
                self?.presentSignUpView = false // 로그인 성공시
                self?.checkNicknameAndAccessLogin()
                return
            }
            
            errorLog("테스트용 로그인 실패 error: \(error)")
        })
    }
    
    private func setUserInfo(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(true, forKey: "isLogin")
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
        networkModel.checkUserNickname(completion: { [weak self] result in
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
        networkModel.postLeaveUser { [weak self] result in
            switch result {
            case .success:
                self?.logoutAction()
            case .failure(let error):
                self?.toastManager.showToast(message: "회원 탈퇴 실패")
                errorLog("🔴 회원 탈퇴 API 실패: \(error.localizedDescription)")
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
