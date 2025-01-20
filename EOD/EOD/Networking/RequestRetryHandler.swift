//
//  RequestRetryHandler.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation
import Alamofire

/// API 실패시 재시도 처리 클래스
public class RequestRetryHandler: RequestInterceptor {
    open var maxRetryCount: Int = 3
    open var retryDelay: Double = 0.5
    
    /// API 실패시 재시도 처리 클래스 생성.
    /// - Parameters:
    ///   - maxRetryCount: 최대 재시도 회수. 기본값은 3초
    ///   - retryDelay: API 실패시 다음 재시도를 하는 딜레이. 기본값은 0.5초
    public init(maxRetryCount: Int = 3, retryDelay: Double = 0.5) {
        self.maxRetryCount = maxRetryCount
        self.retryDelay = max(0, retryDelay)
    }
    
    open func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    open func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        /// 재시도를 할 필요가 있는 에러코드이고, 제한회수를 초과하지 않았으면 재시도를 한다.
        guard request.retryCount < maxRetryCount && retryAvailable(errorCode: request.response?.statusCode) else {
            debugLog("failed to receive response. api url = \(request.request?.url?.absoluteString ?? "nil")\nerror = \(error)")
            
            return completion(.doNotRetryWithError(error.asAFError?.underlyingError ?? error))
        }
        
        debugLog("\(request.retryCount + 1)번째 API 재시도. api = \(request.request?.url?.absoluteString ?? "nil"), error = \(error)")
        completion(.retryWithDelay(retryDelay))
    }
    
    /// API 재시도를 할 필요가 있는 에러코드인지 판단한다.
    open func retryAvailable(errorCode: Int?) -> Bool {
        /// 404 에러면 서버에서 에러 데이터가 내려왔을 것으로 예상하고 재시도하지 않는다.
        return errorCode != 404
    }
}
