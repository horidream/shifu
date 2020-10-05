//
//  CGPointExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/24.
//

import UIKit



public extension CGPoint{
    init(_ x: CGFloat, _ y: CGFloat){
        self.init(x:x, y:y)
    }
    
    func rectTo(_ point:CGPoint)->CGRect{
        return CGRect(origin: self, size: CGSize(width: point.x - self.x, height: point.y - self.y))
    }
    
    func rect(_ width: CGFloat, _ height: CGFloat)->CGRect{
        return CGRect(origin: self, size: CGSize(width: width, height: height))
    }
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
}

public extension CGRect{
    init(_ x: CGFloat, _ y: CGFloat, _ width:CGFloat, _ height: CGFloat){
        self.init(x:x, y:y, width:width, height: height)
    }
    
    var center:CGPoint{
        return CGPoint(x: self.midX, y: self.midY)
    }
}

public extension CGSize{
    init(_ width: CGFloat, _ height: CGFloat){
        self.init(width: width, height: height)
    }
    
    func perspectiveSize(at z: CGFloat, cameraDistance distance: CGFloat)->Self{
        let scale = (distance - z) / distance
        return CGSize(width: scale * width, height: scale * height )
    }
}
