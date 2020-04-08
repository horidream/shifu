//
//  File.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/8.
//

import Foundation


public class Shifu{
    public struct ui{
        public static func blurView(frame:CGRect, style:UIBlurEffect.Style = .light) -> UIVisualEffectView{
            let blur = UIBlurEffect(style: style)
            let ev = UIVisualEffectView(effect: blur)
            ev.frame = frame
            return ev
        }
    }
}
