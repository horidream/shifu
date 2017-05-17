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

extension CALayer: CAAnimationDelegate{
    public func animationDidStart(_ anim: CAAnimation) {
        if let onStart = self.value(forKey: "__shifu_on_start__") as? () -> Void{
            onStart()
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let onComplete = self.value(forKey: "__shifu_on_complete__") as? (Bool) -> Void{
            onComplete(flag)
        }
        
    }
    
    public func onAnimationComplete(_ callback:(Bool)->Void){
        self.setValue(callback, forKey: "__shifu_on_complete__")
    }
    
    public func onAnimaitonStart(_ callback:()->Void){
        self.setValue(callback, forKey: "__shifu_on_start__")
    }
}

extension CALayer:CALayerDelegate{
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == kCAOnOrderIn, let callback = self.value(forKey:"__shifu_on_add_to_stage__") as? ()->Void{
            callback()
            if let action = layer.value(forKey: "__shifu_on_add_to_stage_action__") as? CAAction
            {
                return action
            }
        }
        return nil
    }
    
    public func onAddToStage(action:CAAction? = nil, _ callback:()->Void){
        self.delegate = self
        self.setValue(callback, forKey: "__shifu_on_add_to_stage__")
        if let action = action{
            self.setValue(action, forKey: "__shifu_on_add_to_stage_action__")
        }
    }
}
