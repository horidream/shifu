//
//  GlobalFunctions.swift
//  Pods
//
//  Created by Baoli Zhai on 08/03/2017.
//
//

import Foundation


let namespace:String = "com.horidream.lib.shifu"

public func delay(_ delay:Double, queue:DispatchQueue? = nil, closure:@escaping ()->()) {
    let q = queue ?? DispatchQueue.main
    let t = DispatchTime.now() + Double(Int64( delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    q.asyncAfter(deadline: t, execute: closure)
}
