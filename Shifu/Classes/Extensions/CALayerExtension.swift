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
    
//    public func onAddToStage(action:CAAction? = nil, _ callback:()->Void){
//        self.delegate = self
//        self.setValue(callback, forKey: "__shifu_on_add_to_stage__")
//        if let action = action{
//            self.setValue(action, forKey: "__shifu_on_add_to_stage_action__")
//        }
//    }
}
