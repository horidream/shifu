
//
//  File.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/2/28.
//

import UIKit

public class DismissAnimator: NSObject{
    var anim: UIViewImplicitlyAnimating?
    unowned var modelVC: UIViewController
    public var duration: TimeInterval = 0.15
    private(set) public var isInteractive: Bool = false
    var context:UIViewControllerContextTransitioning?
    public init(_ modelVC: UIViewController, duration:TimeInterval = 0.15){
        print("add pan")
        self.modelVC = modelVC
        self.duration = duration
        super.init()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.delegate = self
        modelVC.view.addGestureRecognizer(panGesture)
    }
    
    @objc func pan(_ g: UIPanGestureRecognizer){
        print(g.state)
        switch g.state {
        case .began:
            self.isInteractive = true
            self.modelVC.dismiss(animated: true, completion: nil)
        case .changed:
            let v = g.view!
            let delta = g.translation(in:v)
            let percent = delta.y/v.bounds.size.height
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

extension DismissAnimator:UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
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
            
            let v1 = ctx.view(forKey:.from)!
            var r1end = v1.frame
            r1end.origin = CGPoint(x: 0, y: r1end.height)
            
            let anim = UIViewPropertyAnimator(duration: self.duration, curve: .linear) {
                v1.frame = r1end;
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



extension DismissAnimator: UIViewControllerInteractiveTransitioning{
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if #available(iOS 10.0, *) {
            self.anim = self.interruptibleAnimator(using: transitionContext)
        } else {
            // Fallback on earlier versions
        }
        self.context = transitionContext;
    }
}

