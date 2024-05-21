import UIKit
import Alamofire

open class APIRequest {
    
    public static let shared = APIRequest()
    
    public var isWifi: Bool { return _isWifi }
    private(set) var _isWifi: Bool = false
    private let reachabilityManager = NetworkReachabilityManager()
    private var ongoingSessionManager: [String: Session] = [:]
    private let sessionManagerHandlingQueue = DispatchQueue(label: "SessionManagerHandlingQueue")
    
    public var isReachable: Bool { return reachabilityManager?.isReachable == true }
    
    private init() {
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            switch status {
            case let .reachable(connectionType):
                self?._isWifi = connectionType == .ethernetOrWiFi
                
            default:
                break
            }
        })
    }
}

// MARK: -

extension APIRequest {
    /// API Request. response는 Decode된 모델로 전달.
    ///
    /// - Remark: response body가 비어있는 API인 경우 204 status code로 내려오면 처리 가능.
    /// - Parameters:
    ///   - api: 사용할 API. relative path만 전달하는 경우는 `UrlBuilder`에서 api gateway 주소와 조합해서 full url을 생성합니다. (ex : "members/{memberId}/documents")
    ///   - method: `HTTPMethod`. 기본값은 `get`
    ///   - parameters: API URL에 추가하는 query parameter dictionary
    ///   - requestParameters: HTTP Request body에 추가하는 parameter dictionary
    ///   - headers: 헤더
    ///   - queue: completion handler가 호출될 Queue
    ///   - retrier: API 실패시 재시도 처리를 해주는 `RequestRetryHandler`
    ///   - completion: completion closure
    /// - Returns: `DataRequest`
    @discardableResult
    public class func requestDecodable<T: Decodable>(
        api: String,
        method: HTTPMethod = .get,
        parameters queryParameters: Parameters? = nil,
        requestParameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        queue: DispatchQueue? = nil,
        retrier: RequestInterceptor? = nil,
        completion: ((Result<T, Error>) -> Void)? = nil) -> DataRequest {
            return requestData(api: api, method: method, parameters: queryParameters, requestParameters: requestParameters, headers: headers, queue: queue, retrier: retrier, completion: { result in
                do {
                    guard let data = result.success else { throw result.error ?? CommonError.failedToFetch }
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion?(.success(decoded))
                } catch {
                    completion?(.failure(error))
                }
            })
        }
    
    /// data response를 받는 API Request
    ///
    /// - Remark: response body가 비어있는 API인 경우 204 status code로 내려오면 처리 가능.
    /// - Parameters:
    ///   - api: 사용할 API. relative path만 전달하는 경우는 `UrlBuilder`에서 api gateway 주소와 조합해서 full url을 생성합니다. (ex : "members/{memberId}/documents")
    ///   - method: `HTTPMethod`. 기본값은 `get`
    ///   - parameters: API URL에 추가하는 query parameter dictionary
    ///   - requestParameters: HTTP Request body에 추가하는 parameter dictionary
    ///   - headers: 헤더
    ///   - queue: completion handler가 호출될 Queue
    ///   - retrier: API 실패시 재시도 처리를 해주는 `RequestRetryHandler`
    ///   - completion: completion closure
    /// - Returns: `DataRequest`
    @discardableResult
    public class func requestData(
        api: String,
        method: HTTPMethod = .get,
        parameters queryParameters: Parameters? = nil,
        requestParameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        queue: DispatchQueue? = nil,
        retrier: RequestInterceptor? = nil,
        completion: ((Result<Data, Error>) -> Void)? = nil) -> DataRequest {
        let (dataRequest, sessionManagerID) = request(api: api, method: method, parameters: queryParameters, requestParameters: requestParameters, headers: headers, queue: queue, retrier: retrier)
        
        dataRequest.response(queue: queue ?? .main) { (response: AFDataResponse<Data?>) -> Void in
            logDurationTime(api: api, duration: response.metrics?.taskInterval.duration)
            
            if let data = response.value, response.error == nil {
                completion?(.success(data ?? Data()))
            } else {
                let error = response.parsedError
                recordError(response: response, method: method, queryParameters: queryParameters, requestParameters: requestParameters)
                completion?(.failure(error))
            }
            
            shared.removeSessionManager(id: sessionManagerID)
        }
        
        return dataRequest
    }
    
    /// Alamofire DataRequest 생성
    ///
    /// - Parameters:
    ///   - api: 사용할 API. relative path만 전달하는 경우는 `UrlBuilder`에서 api gateway 주소와 조합해서 full url을 생성합니다. (ex : "members/{memberId}/documents")
    ///   - apiType: `APIGatewayType`에서 해당되는 타입을 선택한다. 기본값은 `live`
    ///   - method: `HTTPMethod`. 기본값은 `get`
    ///   - parameters: API URL에 추가하는 query parameter dictionary
    ///   - requestParameters: API Request body에 추가하는 parameter dictionary
    ///   - customParameters: dictionary가 아닌 String이나 Array 타입의 파라미터. 일반적으로 잘 사용하지 않는다.
    ///   - headers: 헤더
    ///   - queue: completion handler가 호출될 Queue
    ///   - retrier: API 실패시 재시도 처리를 해주는 `RequestRetryHandler`
    public class func request(
        api: String,
        method: HTTPMethod = .get,
        parameters queryParameters: Parameters? = nil,
        requestParameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        queue: DispatchQueue? = nil,
        retrier: RequestInterceptor? = nil) -> (DataRequest, String) {
            let url = api.isValidUrlHeader ? api : UrlBuilder.createUrl(relativePath: api, parameters: queryParameters)
            debugLog("API Request :: url = \(url)")
            
            let sessionManager = Session.createInstance(retrier: retrier)
            let sessionManagerID = UUID().uuidString
            shared.add(sessionManager: sessionManager, id: sessionManagerID)
            
            let encoding: ParameterEncoding = requestParameters == nil ? URLEncoding.default : JSONEncoding.default
            let dataRequest = sessionManager.request(url, method: method, parameters: requestParameters, encoding: encoding, headers: createHeaders(with: headers)).validate()
            return (dataRequest, sessionManagerID)
        }
    
    /// multipart
    public class func upload(multipartFormData: @escaping (MultipartFormData) -> Void,
                             to url: URLConvertible,
                             method: HTTPMethod = .post,
                             headers: HTTPHeaders? = nil) -> UploadRequest {
        return AF.upload(multipartFormData: multipartFormData,
                         to: url,
                         method: method,
                         headers: createHeaders(with: headers))
    }
}

// MARK: - Headers

extension APIRequest {
    
    private class var userAccessToken: String { return "User-Agent" } // TODO: accessToken 이름 확인
    
    private class func createHeaders(with initialHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers: HTTPHeaders = initialHeaders ?? [:]
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") { // 좀 다르게 접근하는 방법을 찾아보자.
            // User AcessToken
            debugLog("현재 저장되있는 accessToken은 다음과 같습니다. -> \(accessToken)")
            headers[userAccessToken] = accessToken
        }
        
        return headers
    }
}

// MARK: - 에러 처리

extension APIRequest {
    
    private class func recordError<T>(response: AFDataResponse<T>, method: HTTPMethod, queryParameters: Parameters? = nil, requestParameters: Parameters? = nil) {
        // GP 이외의 API (ex. like) 는 result 구조가 달라서 에러로 분류될 수 있다. 이 경우에는 로그 남기지 않음.
        guard let url = response.request?.url?.absoluteString else { return }
        
        let errorCode = response.error?.underlyingError?.code
        let message = """
        \(url)
        method = \(method.rawValue)
        queryParameters = \(queryParameters?.description ?? "nil")
        requestParameters = \(requestParameters?.description ?? "nil")
        rawJson = \(response.getRawJson() ?? "nil")
        \(response.debugDescription)
        """
        
        apiLog(message, errorCode: errorCode, httpStatusCode: response.response?.statusCode)
    }
    
    /// SessionManager를 shared instance의 dictionary에 보관해둔다.
    /// 이렇게 해야 API response를 받을 때까지 SessionManager instance가 release되지 않고 유지됨.
    private func add(sessionManager: Session, id: String) {
        sessionManagerHandlingQueue.async { [weak self] in
            self?.ongoingSessionManager[id] = sessionManager
        }
    }
    
    /// 사용 완료한 SessionManager를 shared instance의 dictionary에서 제거한다.
    public func removeSessionManager(id: String) {
        sessionManagerHandlingQueue.async { [weak self] in
            self?.ongoingSessionManager[id] = nil
        }
    }
    
    /// API 응답속도 로깅
    public class func logDurationTime(api: String, duration: TimeInterval?) {
        guard let duration else { return }
        let durationInMS = (duration * 1000.0).rounded().int
        var relativePath = api.components(separatedBy: "?").first ?? api
        if relativePath.starts(with: "http") == false && relativePath.starts(with: "/") == false {
            relativePath = "/" + relativePath
        }
        debugLog("[API] api=\(relativePath), duration=\(durationInMS)")
    }
}

public extension DataResponse {
    
    /// 서버 응답은 성공이지만 에러 메세지가 내려오는 경우 에러를 추출한다.
    ///
    /// 1. 서버 규칙에 따라 code, message로 이루어진 JSON을 parsing해서 Error를 생성, 리턴하고
    /// 2. 1번을 실패할 경우 response.error를 리턴한다.
    var parsedError: Error {
        if isOfflineError {
            return CommonError.offline
        } else {
            return serverError ?? error?.asAFError?.underlyingError ?? error ?? CommonError.failedToFetch
        }
    }
    
    /// response에서 에러 메세지를 추출해서 message를 리턴한다.
    var parsedErrorMessage: String? {
        let message = try? JSONDecoder().decode(ServerErrorMessage.self, from: self.data ?? Data())
        return message?.messageFromServer
    }
    
    /// 서버에서 의도적으로 내려주는 에러를 추출한다.
    /// `message` field는 필수, `errorCode` field는 옵셔널.
    var serverError: Error? {
        guard let serverErrorMessage = parsedErrorMessage else { return nil }
        return CommonError.server(serverErrorCode, serverErrorMessage)
    }
    
    /// response에서 `errorCode` field 추출
    private var serverErrorCode: Int? {
        let message = try? JSONDecoder().decode(ServerErrorMessage.self, from: self.data ?? Data())
        return message?.errorCode
    }
    
    private var isOfflineError: Bool {
        return error?.asAFError?.original?.code.isOfflineErrorCode == true
            || error?.asAFError?.retry?.code.isOfflineErrorCode == true
            || response?.statusCode.isOfflineErrorCode == true
    }
    
    /// 서버에서 내려주는 에러 메세지 parsing용 모델
    private struct ServerErrorMessage: Decodable {
        let message: String?
        let errorMessage: String?
        let error: String?
        let errorCode: Int?
        
        var messageFromServer: String? { message ?? errorMessage ?? error }
    }
}

fileprivate extension AFError {
    
    var original: Error? { return errorTuple?.1 }
    var retry: Error? { return errorTuple?.0 }
    
    private var errorTuple: (Error, Error)? {
        switch self {
        case .requestRetryFailed(retryError: let retry, originalError: let original):
            return (retry, original)
            
        default: return nil
        }
    }
}
