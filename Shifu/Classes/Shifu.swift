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
    public struct ui{
        public static func blurView(frame:CGRect, style:UIBlurEffect.Style = .light) -> UIVisualEffectView{
            let blur = UIBlurEffect(style: style)
            let ev = UIVisualEffectView(effect: blur)
            ev.frame = frame
            return ev
        }
    }
    
    
}
