//
//  GlobalFunctions.swift
//  Pods
//
//  Created by Baoli Zhai on 08/03/2017.
//
//

import Foundation
import Combine
import SwiftUI


let namespace:String = "com.horidream.lib.shifu"

@discardableResult public func delay(_ delay:Double, queue:DispatchQueue? = nil, closure:@escaping ()->()) -> DispatchWorkItem {
    let q = queue ?? DispatchQueue.main
    let t = DispatchTime.now() + Double(Int64( delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    let workItem = DispatchWorkItem() { closure() }
    q.asyncAfter(deadline: t, execute: workItem)
    return workItem
}

@discardableResult public func with<T>(_ target:T, block:(T)->Void) -> T{
    block(target)
    return target
}

public func suppressConstraitError(){
    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
}

public func performance(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    clg("Time elapsed for \(title): \(timeElapsed) s.")
}

public let fm: FileManager = FileManager.default
public let pb: UIPasteboard = UIPasteboard.general
public let ud = UserDefaults.standard
public typealias url = FileManager.url
public typealias path = FileManager.path
public typealias sc = ShortCut


