//
//  Buildable.swift
//  Shifu
//
//  Created by Baoli Zhai on 2024/6/29.
//

import Foundation

public protocol Buildable {
    init()
}

public extension Buildable {
    static func build(_ builder: (Self) -> Void) -> Self {
        let instance = Self()
        builder(instance)
        return instance
    }
}
