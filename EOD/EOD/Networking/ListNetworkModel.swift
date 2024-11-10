//
//  ListNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation
import Alamofire

public struct RequestInfo {
    public var request: DataRequest?
    public var nextKey: Int?
    
    /// 초기화
    mutating public func reset() {
        request?.cancel()
        request = nil
        nextKey = nil
    }
}

public enum ListRequestError: Error {
    case isLoading  // 이미 로딩중
    case noNextList // 다음 목록이 없음
}

open class ListNetworkModel {
    
    public let retryHandler = RequestRetryHandler()
    public var requestInfo = RequestInfo()
    public let jsonParsingQueue = DispatchQueue.global(qos: .userInteractive)
    open var apiPath: String { return "" }
    
    open var nextKey: Int? {
        get { return requestInfo.nextKey }
        set { requestInfo.nextKey = newValue }
    }
    open var isLoading: Bool { return requestInfo.request != nil }
    open var isNextLoadingAvailable: Bool { return nextKey != nil }
    open var isLoadingOrNextAvailable: Bool { return isLoading || isNextLoadingAvailable }
    
    public init() {}
    
    /// 다음 목록 로딩을 자동으로 처리해주는 API Request
    ///
    /// - Parameters:
    ///   - isRefresh: 새로고침인 경우 true, 다음 목록 로딩이면 false
    ///   - api: api path
    ///   - parameters: 별도의 파라미터가 필요한 경우 사용
    ///   - requestParameters: API Request body에 추가하는 parameter dictionary
    ///   - removeDefaultParameters: next 정보가 defaultParameter로 사용되면 안될 경우 true값을 주어 사용
    ///   - requestClosure: cancel되지 않고, request를 쏠 때 실행할 closure구문 ex) Ace로그
    ///   - parsingQueue: parser를 실행할 Queue. nil일 경우, DispatchQueue.global(qos: .userInteractive)
    ///   - parser: Data를 Model로 decoding하는 closure
    ///   - completion: api 성공 or 실패시
    ///   - cancel: 이미 로딩중이거나 다음 목록이 없어서 API Request를 하지 않고 이벤트가 취소되는 경우에 수행할 closure
    open func requestList<T>(isRefresh: Bool = false,
                             api: String? = nil,
                             parameters: [String: Any]? = nil,
                             requestParameters: [String: Any]? = nil,
                             removeDefaultParameters: Bool = false,
                             requestClosure: (() -> Void)? = nil,
                             parsingQueue: DispatchQueue? = nil,
                             parser: @escaping((Data) -> T),
                             completion: @escaping(Result<T, Error>) -> Void,
                             cancel: ((ListRequestError) -> Void)? = nil) {
        if isRefresh {
            requestInfo.reset()
        }
        
        guard isLoading == false else {
            infoLog("이미 API 로딩중입니다.")
            cancel?(.isLoading)
            return
        }
        
        guard isRefresh || isNextLoadingAvailable else {
            infoLog("더 이상 로딩할 다음 목록이 없습니다.")
            cancel?(.noNextList)
            return
        }
        
        requestClosure?()
        
        let apiPath = api ?? self.apiPath
        let parameters = removeDefaultParameters ? parameters : createParameter(basedOn: parameters)
        debugLog("목록형 API = \(apiPath), parameters = \(String(describing: parameters))")
        
        requestInfo.request = APIRequest.requestData(
            api: apiPath,
            parameters: parameters,
            requestParameters: requestParameters,
            queue: parsingQueue ?? jsonParsingQueue,
            retrier: retryHandler,
            completion: { [weak self] result in
                self?.requestInfo.request = nil
                
                switch result {
                case .success(let data):
                    self?.parseNextLoadingInfo(data: data)
                    let value = parser(data)
                    DispatchQueue.main.async { completion(.success(value)) }
                    
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            })
    }
    
    open func createParameter(basedOn aParameter: [String: Any]?) -> [String: Any] {
        var parameters = UrlBuilder.createParameter(nextKey: requestInfo.nextKey) // TODO: 파라미터 API쪽 확인해봐야함
        aParameter?.keys.forEach({ key in
            parameters[key] = aParameter?[key]
        })
        
        return parameters
    }
    
    /// Parse next key, has next
    open func parseNextLoadingInfo(data: Data) {
        let next = parseNextKey(data: data)
        if (next ?? 0) > 0, requestInfo.nextKey != next {
            requestInfo.nextKey = next
        } else {
            debugLog("목록형 API response의 next page key값이 0이거나 이전과 동일합니다 :: \(String(describing: next)) // nextKey를 삭제해서 반복 로딩을 차단합니다.")
            requestInfo.nextKey = nil
        }
        
        debugLog("목록형 API response의 next page key = \(requestInfo.nextKey?.string ?? "nil")")
    }
    
    /// parse next key
    /// 키값 존재여부만 판단한다. 동일한 nextKey값이 반복해서 사용되므로 기존 키값과 비교는 하지 않는다.
    /// profile > selection 탭의 경우 next key 의 인자가 달라서 override 하여 사용
    open func parseNextKey(data: Data) -> Int? {
        struct NextKey: Decodable {
            let page: Int?
            let next: Int?
            
            enum CodingKeys: CodingKey {
                case page
                case next
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.page = try? container.decodeInteger(key: .page)
                self.next = try? container.decodeInteger(key: .next)
            }
        }
        guard let nextKey = try? JSONDecoder().decode(NextKey.self, from: data) else { return nil }
        return nextKey.page ?? nextKey.next
    }
}
