//
//  Hashed.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/11/19.
//

import Foundation

public class Hashed<T>: Hashable{
    static public func == (lhs: Hashed, rhs: Hashed) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public var payload: T
    var userDefinedHash: AnyHashable?
//    var uuid = UUID()
    
    public init(
        _ payload:T,
        userDefinedHash: @autoclosure ()->AnyHashable? = nil)
    {
        self.payload = payload
        self.userDefinedHash = userDefinedHash()
    }
    
    public func hash(into hasher: inout Hasher) {
        if let userDefinedHash = userDefinedHash {
            hasher.combine(userDefinedHash)
        }else if let payload = payload as? AnyHashable{
            hasher.combine(payload)
        }
    }
}
