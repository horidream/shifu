//
//  ui.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/9/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

import UIKit



public extension UIColor {
    convenience init(_ hexValue:UInt, alpha:CGFloat = 1.0) {
        let r = CGFloat(hexValue >> 16 & 0xFF)/255.0
        let g = CGFloat(hexValue >> 8 & 0xFF)/255.0
        let b = CGFloat(hexValue >> 0 & 0xFF)/255.0
        self.init(red:r,green:g,blue:b,alpha:alpha)
    }
    
    var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    var hexValue: Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let argb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return argb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}





public extension Int{
    func toColor()->UIColor{
        return UIColor(UInt(self))
    }
}
