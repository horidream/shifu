//
//  File.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/8.
//

import UIKit


class EqutableWrapper: Equatable, Identifiable{
    static func == (lhs: EqutableWrapper, rhs: EqutableWrapper) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static var globalID: UInt = 0;
    let id: UInt = {
        globalID += 1
        return globalID;
    }()
    
    var payload: Any? = nil
    
}


public class Shifu{

    public static var name = "Shifu"
    
    public static var maxStitchedImageSize:CGFloat = 1000
    public struct ui{
        public static func blurView(frame:CGRect, style:UIBlurEffect.Style = .light) -> UIVisualEffectView{
            let blur = UIBlurEffect(style: style)
            let ev = UIVisualEffectView(effect: blur)
            ev.frame = frame
            return ev
        }
    }
    
    static let namespace:String = "com.horidream.lib.shifu"

    
    @discardableResult public class func delay(_ delay:Double, queue:DispatchQueue? = nil, closure:@escaping ()->()) -> DispatchWorkItem {
        let q = queue ?? DispatchQueue.main
        let t = DispatchTime.now() + Double(Int64( delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        let workItem = DispatchWorkItem() { closure() }
        q.asyncAfter(deadline: t, execute: workItem)
        return workItem
    }

}
