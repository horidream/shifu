//
//  CombineExtension.swift
//  ClipboardComposer
//
//  Created by Baoli Zhai on 2021/3/6.
//

import Combine
import UIKit
import SwiftUI

fileprivate var count = 1
@available(iOS 13.0, *)
public extension AnyCancellable{
    static var bag:[String:AnyCancellable] = [:]
    private static var _count:Int = 0
    @discardableResult func retain(_ key:String = #file, line:Int = #line ) -> Self {
        let key = "\(key)-\(line)"
        AnyCancellable.bag[key] = self
        return self
    }
    
    static func release(key:String){
        bag[key]?.cancel()
        AnyCancellable.bag.removeValue(forKey: key)
    }
    
    static func releaseAll(test:((String)->Bool) = { _ in true }){
        
        bag.keys.filter(test).forEach { (key) in
            release(key: key)
        }
    }
    static func releaseAll(pattern:String){
        bag.keys.filter({ $0.range(of: pattern, options: .regularExpression) != nil }).forEach { (key) in
            release(key: key)
        }
    }
}

@available(iOS 13.0, *)
public func debounce<T>(_ id:String, closure:@escaping (T)->Void)->((T)->Void){
    
    let publisher = PassthroughSubject<T, Never>()
    publisher.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
       .sink{
           i in
           closure(i)
       }.retain(id)
    return publisher.send
}

@available(iOS 13.0, *)
public func debounce(_ id:String, closure:@escaping ()->Void)->(()->Void){
    
    let publisher = PassthroughSubject<Void, Never>()
    publisher.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
       .sink{ _ in
           closure()
       }.retain(id)
    return publisher.send
}

@available(iOS 13.0, *)
public prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
