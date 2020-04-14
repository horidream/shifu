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
    private(set) public var isInteractive: Bool = false
    var context:UIViewControllerContextTransitioning?
    public init(_ tbc: UITabBarController, interactive isInteractive: Bool = true, duration:TimeInterval = 0.15){
        self.tbc = tbc
        
        self.duration = duration
        super.init()
        if(isInteractive){
            let leftPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pan))
            leftPan.edges = .left
            leftPan.delegate = self
            tbc.view.addGestureRecognizer(leftPan)
            
            let rightPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pan))
            rightPan.edges = .right
            rightPan.delegate = self
            tbc.view.addGestureRecognizer(rightPan)
        }
        self.tbc.delegate = self
    }
    
    @objc func pan(_ g: UIScreenEdgePanGestureRecognizer){
        switch g.state {
        case .began:
            self.isInteractive = true
            if g.edges == .right{
                self.tbc.selectedIndex += 1
            }else{
                self.tbc.selectedIndex -= 1
            }
        case .changed:
            let v = g.view!
            let delta = g.translation(in:v)
            let percent = abs(delta.x/v.bounds.size.width)
            self.anim?.fractionComplete = percent
            self.context?.updateInteractiveTransition(percent)
        case .ended:
            if #available(iOS 10.0, *) {
                if let anim = self.anim as? UIViewPropertyAnimator{
                    anim.pauseAnimation()
                    if anim.fractionComplete < 0.33 {
                        anim.isReversed = true
                    }
                    anim.continueAnimation(
                        withTimingParameters:
                        UICubicTimingParameters(animationCurve:.linear),
                        durationFactor: 0.5)
                    
                }
                
            } else {
                // Fallback on earlier versions
            }
        default:()
            
        }
    }
}


extension BasicTabBarControllerAnimator:UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let idx = self.tbc.selectedIndex
        return (gestureRecognizer as! UIScreenEdgePanGestureRecognizer).edges == .right ?
            idx < self.tbc.viewControllers!.count - 1 : idx > 0
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
            
            anim.addCompletion { finish in
                if(self.isInteractive){
                    if finish == .end{
                        ctx.finishInteractiveTransition()
                        ctx.completeTransition(true)
                    }else{
                        ctx.cancelInteractiveTransition()
                        ctx.completeTransition(false)
                    }
                    
                }else{
                    ctx.completeTransition(true)
                    
                }
            }
            
            self.anim = anim
            return anim
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        self.anim = nil
        self.isInteractive = false
    }
}

extension BasicTabBarControllerAnimator : UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController,
                                 animationControllerForTransitionFrom fromVC: UIViewController,
                                 to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self : nil
    }
}

extension BasicTabBarControllerAnimator: UIViewControllerInteractiveTransitioning{
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if #available(iOS 10.0, *) {
            self.anim = self.interruptibleAnimator(using: transitionContext)
        } else {
            // Fallback on earlier versions
        }
        self.context = transitionContext;
    }
}
