//
//  UIControlExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/3/28.
//

import UIKit

class ClosureSleeve<T> {
    let closure: (T) -> ()
    let target: T
    init(attachTo: T, closure: @escaping (T) -> ()) {
        self.closure = closure
        self.target = attachTo
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc func invoke() {
        closure(self.target)
    }
}

public extension UIControl {
    @available(iOS 9.0, *)
    func addAction<T:UIControl>(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping (T) -> ()) {
        let sleeve = ClosureSleeve(attachTo: self as! T, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve<T>.invoke), for: controlEvents)
    }
}


public extension UIBarButtonItem {
    
    
    public convenience init(title: String?, style: UIBarButtonItem.Style = .plain, closure: @escaping (UIBarButtonItem) -> ()) {
        self.init(title: title, style: style, target: nil, action: nil)
        targetClosure = closure
        action = #selector(UIBarButtonItem.closureAction)
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style = .plain, closure: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, style: style, target: nil, action: nil)
        targetClosure = closure
        action = #selector(UIBarButtonItem.closureAction)
    }
    
    @objc public func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    /// Typealias for UIBarButtonItem closure.
    private typealias UIBarButtonItemTargetClosure = (UIBarButtonItem) -> ()
    
    private class UIBarButtonItemClosureWrapper: NSObject {
        let closure: UIBarButtonItemTargetClosure
        init(_ closure: @escaping UIBarButtonItemTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    public var targetClosure: ((UIBarButtonItem) -> ())? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIBarButtonItemClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIBarButtonItemClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
