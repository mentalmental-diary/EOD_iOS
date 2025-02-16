//
//  NotificationNetworkModel.swift
//  EOD
//
//  Created by JooYoung Kim on 2/16/25.
//

import Foundation

class NotificationNetworkModel {
    /// 앱 푸시알림 device token 등록
    func requestBindDevice(token: String, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        let api = "/api-external/user/push-token"
        
        let param = [
            "pushToken": token
        ]
        
        APIRequest.requestData(api: api, method: .put, requestParameters: param, completion: { result in
            switch result {
            case .success: DispatchQueue.main.async { success?() }
            case .failure(let error): DispatchQueue.main.async { failure?(error) }
            }
        })
    }
    
    /// 앱 푸시알림 device token 해제
    func requestUnbindDevice(token: String, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let api = ""
        APIRequest.requestData(api: api, method: .delete, completion: { result in
            switch result {
            case .success: DispatchQueue.main.async { success?() }
            case .failure(let error): DispatchQueue.main.async { failure?(error) }
            }
        })
    }
}
