//
//  BasicTabBarControllerAnimator.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/2/15.
//

import UIKit

public class BasicTabBarControllerAnimator: NSObject{
    var anim: UIViewImplicitlyAnimating?
    unowned var tbc: UITabBarController
    public var duration: TimeInterval = 0.15
    public init(_ tbc: UITabBarController, duration:TimeInterval = 0.15){
        self.tbc = tbc
        self.duration = duration
    }
}


extension BasicTabBarControllerAnimator : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using ctx: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return duration
    }
    public func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        if #available(iOS 10.0, *) {
            let anim = self.interruptibleAnimator(using: ctx)
            anim.startAnimation()
        } else {
            
        }
    }
    
    @available(iOS 10.0, *)
    public func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating {
            if self.anim != nil{
                return self.anim!
            }
            let vc1 = ctx.viewController(forKey:.from)!
            let vc2 = ctx.viewController(forKey:.to)!
            let con = ctx.containerView
            let r1start = ctx.initialFrame(for:vc1)
            let r2end = ctx.finalFrame(for:vc2)
            let v1 = ctx.view(forKey:.from)!
            let v2 = ctx.view(forKey:.to)!
            let ix1 = self.tbc.viewControllers!.firstIndex(of:vc1)!
            let ix2 = self.tbc.viewControllers!.firstIndex(of:vc2)!
            let dir : CGFloat = ix1 < ix2 ? 1 : -1
            var r1end = r1start
            r1end.origin.x -= r1end.size.width * dir
            var r2start = r2end
            r2start.origin.x += r2start.size.width * dir
            v2.frame = r2start
            con.addSubview(v2)
            let anim = UIViewPropertyAnimator(duration: self.duration, curve: .linear) {
                v1.frame = r1end
                v2.frame = r2end
            }
            
            anim.addCompletion { _ in
                ctx.completeTransition(true)
            }
            
            self.anim = anim
            return anim
    }
    public func animationEnded(_ transitionCompleted: Bool) {
        self.anim = nil
    }
}

extension BasicTabBarControllerAnimator : UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return self
    }
}
