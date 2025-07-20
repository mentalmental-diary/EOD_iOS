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
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            let uuidString = request.task?.taskDescription,
            let uuid = UUID(uuidString: uuidString),
            let data = RequestCache.shared.get(id: uuid),
            let serverError = try? JSONDecoder().decode(ServerErrorMessage.self, from: data),
            let code = serverError.errorCode
        else {
            completion(.doNotRetry)
            return
        }

        switch code {
        case 40102:
            attemptTokenRefresh(completion: completion)

        case 40107:
            triggerLogout()
            completion(.doNotRetry)

        default:
            completion(.doNotRetry)
        }
    }

    private func attemptTokenRefresh(completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        defer { lock.unlock() }

        retryQueue.append(completion)
        guard !isRefreshing else { return }

        isRefreshing = true

        guard
            let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
            let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
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

        APIRequest.requestData(api: api, method: .post, requestParameters: param) { [weak self] result in
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

                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
                debugLog("🔁 토큰 재발급 성공: \(response.accessToken)")
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
