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
    @Published var isToast: Bool = false
    var toastMessage: String = ""
    
    @Published var showUserInfoSetView: Bool = false
    
    var presentLoginView: Bool = false // 로그인뷰가 노출되어있는지 확인 -> 회원가입뷰에서 왔다갔다 하기 위해
    var presentSignUpView: Bool = false // 회원가입뷰가 노출되어있는지 확인 -> 로그인뷰와 왔다갔다 하기 위해
    
    @Published var naverLoginError: Error? = nil
    
    private var cancellables = Set<AnyCancellable>() // Combine 구독 관리
    
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
    func logoutAction() {
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        self.isLogin = false
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
                    self.toastMessage = "카카오 로그인 연동 실패했습니다."
                    withAnimation(.easeInOut(duration: 0.6)) {
                        self.isToast = true
                    }
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
                        self.toastMessage = "네아로 연동 실패했습니다."
                        withAnimation(.easeInOut(duration: 0.6)) {
                            self.isToast = true
                        }
                        errorLog("🔴 네아로 연동 후 서버 연동 실패: \(error.localizedDescription)")
                    })
                case .failure(let error):
                    self.naverLoginError = error
                    errorLog("🔴 네이버 로그인 연동 실패: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    func appleLoginAction(userIdentifier: String) {
        self.networkModel.fetchLogin(Authorization: userIdentifier, type: .`self`, completion: { result in // TODO: 타입 변경 예정
            
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
                self?.toastMessage = "닉네임 여부 판단 실패"
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
                errorLog("🔴 닉네임 존재 여부 판단 API 실패: \(error.localizedDescription)")
            }
        })
    }
    
    /// 닉네임 설정
    func setNickname(nickName: String) {
        networkModel.setUserNickname(nickName: nickName, completion: { [weak self] result in
            switch result {
            case .success: // 닉네임 설정 성공
                self?.isLogin = true
            case .failure(let error):
                self?.toastMessage = "닉네임 설정 실패"
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.isToast = true
                }
                errorLog("🔴 닉네임 설정 API 실패: \(error.localizedDescription)")
            }
        })
    }
}

// MARK: - TAB ITEM CASE
enum Tab: String {
    case Home = "home"
    case Calender = "calender"
    case Game = "game"
//    case Shop = "shop"
    case My = "my"
    
    var title: String {
        switch self {
        case .Home: return "홈"
        case .Calender: return "캘린더"
        case .Game: return "게임"
//        case .Shop: return "상점"
        case .My: return "마이페이지"
        }
    }
    
    var iconName: String {
        switch self {
        case .Home: return "icon_home"
        case .Calender: return "icon_calander"
        case .Game: return "icon_game"
//        case .Shop: return "icon_shop"
        case .My: return "icon_my"
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
