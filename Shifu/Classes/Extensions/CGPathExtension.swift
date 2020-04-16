//
//  CGPathExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/16.
//

import Foundation

public extension CGPath{
    //TODO: integrate https://github.com/pocketsvg/PocketSVG
    func translate(_ x: CGFloat? = nil, _ y:CGFloat? = nil) -> CGPath? {
        let rect = self.boundingBox
        let tx = x ?? -rect.origin.x;
        let ty = y ?? -rect.origin.y;
        
        var transform = CGAffineTransform(translationX: tx, y: ty)
        return self.copy(using: &transform)
    }
}
