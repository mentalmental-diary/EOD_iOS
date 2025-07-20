//
//  RequestCache.swift
//  EOD
//
//  Created by JooYoung Kim on 7/20/25.
//

import Alamofire
import Foundation

final class RequestCache {
    static let shared = RequestCache()
    
    private var cache = [UUID: Data]()
    private let queue = DispatchQueue(label: "RequestCacheQueue")
    
    private init() {}
    
    func set(data: Data, for id: UUID) {
        queue.async {
            self.cache[id] = data
        }
    }
    
    func get(id: UUID) -> Data? {
        queue.sync {
            return self.cache[id]
        }
    }
    
    func remove(id: UUID) {
        queue.async {
            self.cache.removeValue(forKey: id)
        }
    }
}
