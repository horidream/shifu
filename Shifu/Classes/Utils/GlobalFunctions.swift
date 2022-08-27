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
    let t = DispatchTime.now() + delay
    let workItem = DispatchWorkItem() { closure() }
    q.asyncAfter(deadline: t, execute: workItem)
    return workItem
}

public func runOnce(file:String = #file, line:Int = #line, block:()->Void){
    let id = "\(file)-\(line)"
    class Status {
        static var dic = [String: Bool]()
        static func canRun(_ id:String)->Bool{
            return dic[id] ?? true
        }
        static func didRun(_ id:String){
            dic[id] = false
        }
    }
    
    if(Status.canRun(id)){
        block()
        Status.didRun(id)
    }
}

@discardableResult public func with<T>(_ target:T, block:(T)->Void) -> T{
    block(target)
    return target
}

public func computedBinding<T>(_ wrapped: @autoclosure @escaping ()->T)->Binding<T>{
    return Binding(get: wrapped, set: { _ in })
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

public func withoutCAAnimation(_ block:()->Void){
    CATransaction.begin()
    CATransaction.setValue(true, forKey: kCATransactionDisableActions)
    block()
    CATransaction.commit()
}

public let fm: FileManager = FileManager.default
public let pb: UIPasteboard = UIPasteboard.general
public let ud = UserDefaults.standard
public typealias url = FileManager.url
public typealias path = FileManager.path
public typealias sc = ShortCut


