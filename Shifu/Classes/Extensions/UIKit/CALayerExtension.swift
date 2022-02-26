//
//  CALayerExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 21/01/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//

import UIKit

public extension CALayer{
    var image:UIImage?{
        UIGraphicsBeginImageContext(self.bounds.size)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var hasAnimation:Bool{
        return self.animationKeys()?.count ?? 0 > 0
    }
    
    func quickAlign(_ type:UInt = 5, _ offsetX:CGFloat = 0, _ offsetY:CGFloat = 0){
        func translateLayerPosition(_ p:CGPoint)->CGPoint{
            return p.applying(.init(translationX: (anchorPoint.x-0.5)*frame.width, y: (anchorPoint.y-0.5)*frame.height))
        }
        if let parent = self.superlayer{
            let pb = parent.bounds
            let halfSize = CGPoint(x: bounds.width/2, y : bounds.height/2);
            switch type {
            
            case 1:
                self.position = translateLayerPosition(pb.origin + halfSize)
            case 2:
                self.position = translateLayerPosition(CGPoint(x: pb.midX, y: halfSize.y))
            case 3:
                self.position = translateLayerPosition(CGPoint(x: pb.maxX - halfSize.x, y: halfSize.y))
            case 4:
                self.position = translateLayerPosition(CGPoint(x: halfSize.x, y: pb.midY))
            case 5:
                self.position = translateLayerPosition(pb.center)
            case 6:
                self.position = translateLayerPosition(CGPoint(x: pb.maxX - halfSize.x, y: pb.midY))
            case 7:
                self.position = translateLayerPosition(CGPoint(x: halfSize.x, y: pb.maxY - halfSize.y))
            case 8:
                self.position = translateLayerPosition(CGPoint(x: pb.minX, y: pb.maxY - halfSize.y))
            case 9:
                self.position = translateLayerPosition(CGPoint(x: pb.maxX - halfSize.x, y: pb.maxY - halfSize.y))
            case 0:
                self.frame = pb
            default:()
                
            }
        }
    }
}

public let kShifuOnAdded = "__shifu_on_add_to_stage__"
extension CALayer:CALayerDelegate{
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == kCAOnOrderIn, let callback = self.value(forKey:kShifuOnAdded) as? ()->Void{
            callback()
            if let action = layer.value(forKey: "__shifu_on_add_to_stage_action__") as? CAAction
            {
                return action
            }
        }
        return nil
    }
}
