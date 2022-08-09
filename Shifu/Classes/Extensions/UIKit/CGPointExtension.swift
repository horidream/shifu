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
    
    static func random(in rect: CGRect, exclude: CGRect = .zero)->CGPoint{
        let center = exclude.center
        let offsetX = exclude.width / 2
        let offsetY = exclude.height / 2
        let x = CGFloat.random(in: rect.minX...rect.maxX)
        let y = CGFloat.random(in: rect.minY...rect.maxY)
        return CGPoint(x: x < center.x ? x - offsetX : x + offsetY , y: y < center.y ? y - offsetY : y + offsetY)
    }
    
    func rectTo(_ point:CGPoint)->CGRect{
        return CGRect(origin: self, size: CGSize(width: point.x - self.x, height: point.y - self.y))
    }
    
    func rect(_ width: CGFloat, _ height: CGFloat)->CGRect{
        return CGRect(origin: self, size: CGSize(width: width, height: height))
    }
    
    func distance(to: CGPoint = .zero) -> CGFloat{
        let p = self - to
        return sqrt(p.x * p.x + p.y * p.y)
    }
    
    func rotated(around origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = x - origin.x
        let dy = y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + byDegrees * .pi / 180.0 // to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
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
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(left.width + right.width, left.height + right.height)
    }
    
    init(_ size: CGFloat){
        self.init(width: size, height: size)
    }
    
    init(_ width: CGFloat, _ height: CGFloat){
        self.init(width: width, height: height)
    }
    
    func scale(_ scale: CGFloat)->Self{
        return CGSize(self.width * scale, self.height * scale);
    }
    
    func extends(_ width:CGFloat, _ height: CGFloat)->CGSize{
        return CGSize(self.width + width, self.height + height);
    }
    
    var cgPoint:CGPoint{
        return CGPoint(self.width, self.height);
    }
    
    func perspectiveSize(at z: CGFloat, cameraDistance distance: CGFloat)->Self{
        let scale = (distance - z) / distance
        return CGSize(width: scale * width, height: scale * height )
    }
}
