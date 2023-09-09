//
//  ErrorCode.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import Foundation

/// 서버에서 내려오는 에러코드
public enum ErrorCode: Int, CaseIterable {
    // MARK: - 필수 정보 미충족
    
    /// 필수정보가 미충족된 경우
    case invalidRequiredInformation = 1002
}
