//
//  KeyedDecodingContainer.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation

extension KeyedDecodingContainer {
    /// array를 decode하는 경우 element중에서 malformed data를 제외한다.
    /// - Parameters:
    ///   - type: array의 element 타입. `[Product]`를 decoding하려고 한다면 `Product.self`를 파라미터로 넘긴다.
    ///   - key: The key that the decoded value is associated with.
    /// - Returns: array를 리턴한다. 모든 element가 invalid하다면 빈 어레이가 리턴된다.
    public func decodeOptionalArray<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> [T] where T: Decodable {
        try decode([OptionalObject<T>].self, forKey: key).compactMap(\.value)
    }
    
    /// 필드값이 Int인 경우 Int/String 두 타입 모두 확인해서 Int로 리턴한다.
    public func decodeInteger(key: KeyedDecodingContainer.Key) throws -> Int? {
        if let intValue = try? self.decodeIfPresent(Int.self, forKey: key) {
            return intValue
        } else if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            if let intValue = stringValue.int {
                return intValue
            } else {
                throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: [key], debugDescription: "Int값이 아닌 스트링입니다."))
            }
        } else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: [key], debugDescription: "key에 해당하는 Int/String 값이 없습니다."))
        }
    }
}
