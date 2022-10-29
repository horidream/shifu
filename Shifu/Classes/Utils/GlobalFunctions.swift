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

extension NSObject: Cacheable {}
extension DispatchWorkItem: Cacheable {}
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

func localized(_ key: String, comment: String? = nil)->String{
    return NSLocalizedString(key, bundle: Shifu.bundle, comment: comment ?? key)
}


public class cache{
    static public private(set) var map = [AnyHashable: [AnyHashable: Any?]]()
    public static func set(key: AnyHashable = #function, _ value: Any?, expire:TimeInterval? = nil, group:AnyHashable = #file){
        if map[group] == nil {
            map[group] = [AnyHashable: Any?]()
        }
        map[group]?[key] = value
        if let expire {
            delay(expire) {
                map[group]?[key] = nil
            }
        }
    }
    public static func get<T>(key:AnyHashable = #function, _ type:T.Type, group:AnyHashable = #file)->T?{
        map[group]?[key] as? T ?? nil
    }
    
    public static func get(key:AnyHashable = #function, group:AnyHashable = #file)->Any?{
        map[group]?[key] ?? nil
    }
}
typealias _cache = cache

public protocol Cacheable{
    func cache(key: AnyHashable , expire:TimeInterval?, group:AnyHashable)
}

public extension Cacheable {
    public func cache(key: AnyHashable = #function, expire:TimeInterval? = nil, group:AnyHashable = #file){
        _cache.set(key: key, self, expire: expire, group: group)
    }
}



public let fm: FileManager = FileManager.default
public let pb: UIPasteboard = UIPasteboard.general
public let ud = UserDefaults.standard
public typealias url = FileManager.url
public typealias path = FileManager.path
public typealias sc = ShortCut
public let nc = NotificationCenter.default


