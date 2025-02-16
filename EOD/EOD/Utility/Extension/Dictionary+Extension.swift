//
//  Dictionary+Extension.swift
//  EOD
//
//  Created by JooYoung Kim on 2/16/25.
//

import Foundation

extension Dictionary {
    /// Push payload 로깅용 기능. 유니코드로 인코딩된 한글을 디코딩해서 json 형태로 로깅한다.
    /// - Remark: 로그용으로 사용할 건데 optional로 리턴하면 사용하는 쪽에서 불편하니 nil일 경우 빈값으로 보낸다.
    public var unicodeDecoded: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
