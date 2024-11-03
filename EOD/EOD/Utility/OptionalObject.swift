//
//  OptionalObject.swift
//  EOD
//
//  Created by JooYoung Kim on 11/3/24.
//

import Foundation

/// Array를 decode할 때 malformed data를 제외한 나머지를 decode하기 위한 wrapper object
public struct OptionalObject<T: Decodable>: Decodable {
    public let value: T?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            value = try container.decode(T.self)
        } catch {
            verboseLog(error.localizedDescription)
            value = nil
        }
    }
}

extension OptionalObject: CustomStringConvertible {
    public var description: String {
        guard let value else { return "nil" }
        return (value as? CustomStringConvertible)?.description ?? String(describing: value)
    }
}
