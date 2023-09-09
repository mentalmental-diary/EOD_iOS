//
//  Logger.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import Foundation

public func log(severity: LogSeverity, msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
    Log.channel(severity: severity)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

public func verboseLog(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
    Log.channel(severity: .verbose)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

public func debugLog(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
    Log.channel(severity: .debug)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

public func infoLog(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
    Log.channel(severity: .info)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

public func warningLog(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
    Log.channel(severity: .warning)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

public func errorLog(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
    Log.channel(severity: .error)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

public func apiLog(_ msg: String, function: String = #function, filePath: String = #file, fileLine: Int = #line, errorCode: Int? = nil, httpStatusCode: Int? = nil) {
    let severity: LogSeverity = {
        if let httpStatusCode, (500..<600).contains(httpStatusCode) { return .error }
        guard let errorCode else { return .warning }
        
        if NSError.networkErrorCodes.contains(errorCode) {
            // 네트워크 에러는 debug level
            return .debug
        } else if ErrorCode.allCases.map(\.rawValue).contains(errorCode) {
            // 사전에 협의된 서버 에러는 warning level
            return .warning
        } else {
            // 사전에 협의되지 않은 unknown 에러는 error level -> 지속적으로 모니터링하면서 계속 조절 예정.
            return .error
        }
    }()
    
    Log.channel(severity: severity)?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
}

// MARK: -

extension NSError {
    
    fileprivate static var networkErrorCodes: [Int] {
        [NSURLErrorTimedOut, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet, NSURLErrorCancelled, NSURLErrorDataNotAllowed]
    }
}
