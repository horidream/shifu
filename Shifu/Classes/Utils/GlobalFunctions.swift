//
//  GlobalFunctions.swift
//  Pods
//
//  Created by Baoli Zhai on 08/03/2017.
//
//

import Foundation
import Combine


let namespace:String = "com.horidream.lib.shifu"

@discardableResult public func delay(_ delay:Double, queue:DispatchQueue? = nil, closure:@escaping ()->()) -> DispatchWorkItem {
    let q = queue ?? DispatchQueue.main
    let t = DispatchTime.now() + Double(Int64( delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    let workItem = DispatchWorkItem() { closure() }
    q.asyncAfter(deadline: t, execute: workItem)
    return workItem
}

public var fm: FileManager {
    return FileManager.default
}

public var pb: UIPasteboard{
    return UIPasteboard.general
}

public typealias url = FileManager.url
public typealias path = FileManager.path
public typealias sc = ShortCut


