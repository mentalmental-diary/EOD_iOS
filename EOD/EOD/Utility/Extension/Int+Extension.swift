//
//  Int+Extension.swift
//  EOD
//
//  Created by JooYoung Kim on 10/3/24.
//

import Foundation

public extension Int {
    
    /// 1자리수 숫자인 경우 앞에 0을 붙여서 두글자 스트링을 리턴한다.
    var zeroPrefixed: String {
        return String(format: "%.2d", self)
    }
    
    /// 년도를 두자리로 표시
    var shortYear: String {
        return String(format: "%02d", self % 100)
    }
    
    func formattedDecimal() -> String {
        let numberFomatter = NumberFormatter()
        numberFomatter.numberStyle = .decimal
        return numberFomatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
