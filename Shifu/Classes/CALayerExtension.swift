//
//  CALayerExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 21/01/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//

import Foundation

extension CALayer{
    public var image:UIImage?{
        UIGraphicsBeginImageContext(self.bounds.size)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
