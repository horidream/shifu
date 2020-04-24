//
//  CGPointExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/24.
//

import Foundation

public extension CGPoint{
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}

public extension CGRect{
    var center:CGPoint{
        return CGPoint(x: self.midX, y: self.midY)
    }
}
