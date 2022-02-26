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
