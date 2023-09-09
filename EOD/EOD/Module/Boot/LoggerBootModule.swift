//
//  LoggerBootModule.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import Foundation

class LoggerBootModule: BootLoaderProtocol {
    
    class func loadModule() {
        Log.enable(configuration: [ConsoleLogRecorder.configuration(minimumSeverity: .debug)])
    }
}
