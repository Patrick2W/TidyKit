//
//  URL+Tidy.swift
//  TidyExtension
//
//  Created by wh on 2024/3/5.
//

import Foundation

public extension TidyExtensionWrapper where Base == URL {
    
    var components: URLComponents? {
        return URLComponents(url: base, resolvingAgainstBaseURL: true)
    }
    
    var query: [String: String] {
        guard let components = components, let items = components.queryItems else {
            return [:]
        }
        var query: [String: String] = [:]
        items.forEach { item in query[item.name] = item.value ?? "" }
        return query
    }
}
