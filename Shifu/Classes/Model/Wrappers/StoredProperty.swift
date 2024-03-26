//
//  StoredProperty.swift
//  Shifu
//
//  Created by Baoli Zhai on 2024/3/26.
//

import Foundation
import SwiftUI

class Storage {
    var values: [String: Any] = [:]

    init(values: [String: Any] = [:]) {
        self.values = values
    }
}
let globalStorage = Storage()
@propertyWrapper
public struct StoredProperty<T> {
    let key: String
    var fallback: T
    var storage: Storage

    public var wrappedValue: T {
        get {
            if let value = storage.values[key] as? T {
                return value
            } else {
                storage.values[key] = fallback
                return fallback
            }
        }
        set {
            storage.values[key] = newValue
        }
    }

    public init(_ key: String, _ defaultValue: T, fileName: String = #file, lineNumber: Int = #line) {
        self.fallback = defaultValue
        self.key = "\(fileName)::\(lineNumber)::\(key)"
        self.storage = globalStorage
    }
    
    public init(_ key: String, _ defaultValue: T, _ rawStorage: inout [String: Any], fileName: String = #file, lineNumber: Int = #line) {
        self.fallback = defaultValue
        self.key = "\(fileName)::\(lineNumber)::\(key)"
        self.storage = Storage(values: rawStorage)
    }
}
