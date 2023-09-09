//
//  LogRecorder.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import Foundation

private typealias ErrorInfo = (errorType: String?, errorCode: String?)

open class ConsoleLogRecorder: StandardStreamsLogRecorder {
    
    /// 콘솔에 로그를 출력하는 Log Configuration을 생성한다.
    /// - Parameter minimumSeverity: 로그 최소레벨. verbose < debug < info < warning < error 순서
    /// - Returns: 'LogConfiguration' instance
    public class func configuration(minimumSeverity: LogSeverity) -> LogConfiguration {
        return BasicLogConfiguration(minimumSeverity: minimumSeverity, recorders: [ConsoleLogRecorder(formatters: [logFormatter])])
    }
    
    private class var logFormatter: LogFormatter {
        return FieldBasedLogFormatter(fields: [
            .timestamp(.custom("HH:mm:ss.SSS")),
            .literal(" | "),
            .callSite,
            .severity(.custom(textRepresentation: .colorCoded, truncateAtWidth: nil, padToWidth: 2, rightAlign: true)),
            .literal(" : "),
            .payload
        ])
    }
}
