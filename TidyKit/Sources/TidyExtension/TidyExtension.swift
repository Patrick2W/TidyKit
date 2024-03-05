//
//  TidyExtension.swift
//  TidyExtension
//
//  Created by wh on 2024/3/5.
//

import Foundation

public struct TidyExtensionWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol TidyExtensible { }

extension TidyExtensible {
    
    public static var td: TidyExtensionWrapper<Self>.Type {
        get { TidyExtensionWrapper<Self>.self }
        set { }
    }
    
    public var td: TidyExtensionWrapper<Self> {
        get { return TidyExtensionWrapper(self) }
        set { }
    }
}

extension NSObject: TidyExtensible { }

extension String: TidyExtensible { }
extension Calendar: TidyExtensible { }
extension Locale: TidyExtensible { }
extension Date: TidyExtensible { }
extension URL: TidyExtensible { }
