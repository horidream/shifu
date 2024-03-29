//
//  DictionaryExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/29.
//

import Foundation
import JavaScriptCore

public struct KeyPath {
    var segments: [String]
    
    var isEmpty: Bool { return segments.isEmpty }
    var path: String {
        return segments.joined(separator: ".")
    }
    
    /// Strips off the first segment and returns a pair
    /// consisting of the first segment and the remaining key path.
    /// Returns nil if the key path has no segments.
    func headAndTail() -> (head: String, tail: KeyPath)? {
        guard !isEmpty else { return nil }
        var tail = segments
        let head = tail.removeFirst()
        return (head, KeyPath(segments: tail))
    }
}

extension KeyPath {
    init(_ string: String) {
        segments = string.components(separatedBy: ".")
    }
}

extension KeyPath: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

public protocol StringConvertible {
    init(string s: String)
}

extension String: StringConvertible {
    public init(string s: String) {
        self = s
    }
}

public extension Dictionary where Key: StringConvertible {
    subscript(keyPath keyPath: KeyPath) -> Any? {
        get {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return nil
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                let key = Key(string: head)
                return self[key]
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                let key = Key(string: head)
                switch self[key] {
                case let nestedDict as [Key: Any]:
                    // Next nest level is a dictionary.
                    // Start over with remaining key path.
                    return nestedDict[keyPath: remainingKeyPath]
                default:
                    // Next nest level isn't a dictionary.
                    // Invalid key path, abort.
                    return nil
                }
            }
        }
        set {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                let key = Key(string: head)
                self[key] = newValue as? Value
            case let (head, remainingKeyPath)?:
                let key = Key(string: head)
                let value = self[key]
                switch value {
                case var nestedDict as [Key: Any]:
                    // Key path has a tail we need to traverse
                    nestedDict[keyPath: remainingKeyPath] = newValue
                    self[key] = nestedDict as? Value
                default:
                    // Invalid keyPath
                    return
                }
            }
        }
    }
}
extension Dictionary where Key: StringConvertible {
    subscript(string keyPath: KeyPath) -> String? {
        get { return self[keyPath: keyPath] as? String }
        set { self[keyPath: keyPath] = newValue }
    }
    
    subscript(dict keyPath: KeyPath) -> [Key: Any]? {
        get { return self[keyPath: keyPath] as? [Key: Any] }
        set { self[keyPath: keyPath] = newValue }
    }
}


public extension JSValue{
    subscript(_ keyPath:KeyPath)->Any?{
        if let obj = self.toObject() as? Dictionary<String, Any>{
            return obj[keyPath: keyPath]
        }else{
            return nil
        }
    }
}

public extension Dictionary where Key == AnyHashable, Value == Any{
    func get(_ key: AnyHashable, fallback: Any? = nil)-> Any?{
        return self[key] ?? fallback
    }
}
