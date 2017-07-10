//
//  CGFloatExtension.swift
//  FMDB
//
//  Created by Baoli Zhai on 07/07/2017.
//

import Foundation

extension CGFloat{
    public func toRadian()->CGFloat{
        return self / 180 * CGFloat.pi
    }
    
    public func toDegree()->CGFloat{
        return self / CGFloat.pi * 180
    }
}

extension Float{
    public var cgFloat:CGFloat{
        return CGFloat(self)
    }
    
    public func toRadian()->CGFloat{
        return CGFloat(self) / 180 * CGFloat.pi
    }
    
    public func toDegree()->CGFloat{
        return CGFloat(self) / CGFloat.pi * 180
    }
}

extension Int{
    public var cgFloat:CGFloat{
        return CGFloat(self)
    }
    
    public func toRadian()->CGFloat{
        return CGFloat(self) / 180 * CGFloat.pi
    }
    
    public func toDegree()->CGFloat{
        return CGFloat(self) / CGFloat.pi * 180
    }
}
