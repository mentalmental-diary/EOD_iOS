//
//  Result+Extension.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import Foundation

// Alamofire.Result랑 겹치는 경우가 많아 typealias 선언
public typealias Result = Swift.Result

public extension Result {
    
    var success: Success? {
        switch self {
        case .success(let element): return element
        case .failure: return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
    
    /// 에러 메세지. 에러가 nil이면 앱 공용 기본 에러문구 리턴
    var errorMessage: String {
        return error?.localizedDescription ?? "일시적 오류입니다. 잠시 후 다시 시도해 주세요."
    }
}

extension Result where Success: Any {
    /// Result<Any, Error> 를 Result<Void, Error> 로 변환하는 코드.
    @inlinable public func voidMap() -> Result<Void, Failure> {
        map({ _ in })
    }
    
    /// Result<특정타입, Error> 를 Result<Any, Error> 로 변환하는 코드.
    @inlinable public func anyMap() -> Result<Any, Failure> {
        map { $0 as Any }
    }
}
