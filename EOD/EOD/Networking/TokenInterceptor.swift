//
//  TokenInterceptor.swift
//  EOD
//
//  Created by JooYoung Kim on 7/20/25.
//
import Alamofire
import Foundation

final class TokenInterceptor: RequestInterceptor {

    private let lock = NSLock()
    private var isRefreshing = false
    private var retryQueue: [(RetryResult) -> Void] = []

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        debugLog("🔄 TokenInterceptor.retry 호출됨")
        
        guard let response = request.task?.response as? HTTPURLResponse else {
            debugLog("❌ response를 HTTPURLResponse로 캐스팅 실패")
            completion(.doNotRetry)
            return
        }
        
        debugLog("📊 HTTP Status Code: \(response.statusCode)")
        guard response.statusCode == 401 else {
            debugLog("❌ 401이 아닌 상태코드: \(response.statusCode)")
            completion(.doNotRetry)
            return
        }
        
        // Request에서 직접 response data 가져오기
        guard let dataRequest = request as? DataRequest,
              let data = dataRequest.data else {
            debugLog("❌ DataRequest로 캐스팅 실패하거나 data가 nil")
            completion(.doNotRetry)
            return
        }
        
        debugLog("📦 Response 데이터 길이: \(data.count) bytes")
        debugLog("📦 Response 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
        
        guard let serverError = try? JSONDecoder().decode(ServerErrorMessage.self, from: data) else {
            debugLog("❌ ServerErrorMessage 디코딩 실패")
            completion(.doNotRetry)
            return
        }
        
        guard let code = serverError.errorCode else {
            debugLog("❌ errorCode가 nil")
            completion(.doNotRetry)
            return
        }
        
        debugLog("🔢 Error Code: \(code)")

        switch code {
        case 40102:
            debugLog("✅ 토큰 갱신 시도")
            attemptTokenRefresh(completion: completion)

        case 40107:
            debugLog("✅ 로그아웃 처리")
            triggerLogout()
            completion(.doNotRetry)

        default:
            debugLog("❌ 알 수 없는 에러 코드: \(code)")
            completion(.doNotRetry)
        }
    }

    private func attemptTokenRefresh(completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        defer { lock.unlock() }

        retryQueue.append(completion)
        debugLog("📋 대기열에 추가됨. 현재 대기 중인 요청 수: \(retryQueue.count)")
        
        guard !isRefreshing else { 
            debugLog("⏳ 이미 토큰 갱신 진행 중 - 대기열에서 대기")
            return 
        }

        isRefreshing = true

        guard
            let accessToken = UserDefaultsManager.shared.accessToken,
            let refreshToken = UserDefaultsManager.shared.refreshToken
        else {
            triggerLogout()
            completeAll(with: .doNotRetry)
            return
        }

        let api = "/api-external/auth/token/refresh"
        let param: [String: Any] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]

        // 토큰 갱신 API는 TokenInterceptor 없이 호출 (무한 루프 방지)
        APIRequest.requestData(api: api, method: .post, requestParameters: param, retrier: EmptyInterceptor()) { [weak self] result in
            guard let self = self else { return }
            self.lock.lock(); defer { self.lock.unlock() }

            switch result {
            case .success(let data):
                guard
                    let response = try? JSONDecoder().decode(RefreshTokenResponse.self, from: data),
                    !response.accessToken.isEmpty
                else {
                    self.triggerLogout()
                    self.completeAll(with: .doNotRetry)
                    return
                }

                UserDefaultsManager.shared.accessToken = response.accessToken
                UserDefaultsManager.shared.refreshToken = response.refreshToken
                debugLog("🔁 토큰 재발급 성공: \(response.accessToken)")
                debugLog("✅ \(self.retryQueue.count)개의 대기 중인 요청들을 재시도합니다")
                self.completeAll(with: .retry)

            case .failure:
                self.triggerLogout()
                self.completeAll(with: .doNotRetry)
            }
        }
    }

    private func completeAll(with result: RetryResult) {
        let completions = retryQueue
        retryQueue.removeAll()
        isRefreshing = false
        completions.forEach { $0(result) }
    }

    private func triggerLogout() {
        debugLog("🚪 로그아웃 처리 시작 - tokenExpiredNotification 발송")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .tokenExpiredNotification, object: nil)
        }
    }
}

// 서버 에러 메시지 디코딩 모델
private struct ServerErrorMessage: Decodable {
    let errorCode: Int?
    let message: String?
    let errorMessage: String?
    let error: String?

    var messageFromServer: String? {
        return message ?? errorMessage ?? error
    }
}

struct RefreshTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

// 토큰 갱신 시 무한 루프 방지를 위한 빈 인터셉터
final class EmptyInterceptor: RequestInterceptor {
    // 아무 동작도 하지 않음
}
