//
//  CombineExtension.swift
//  ClipboardComposer
//
//  Created by Baoli Zhai on 2021/3/6.
//

import Combine
import UIKit
import SwiftUI

fileprivate func getRetainKey(key:String, line:Int)->String{
    return "\(key)-\(line)"
}

@available(iOS 13.0, *)
public extension AnyCancellable{
    static var bag:[String:AnyCancellable] = [:]
    @discardableResult func retain(_ key:String = #file, line:Int = #line ) -> Self {
        let key = getRetainKey(key: key, line: line)
        AnyCancellable.bag[key] = self
        return self
    }
    
    
    
    func release(){
        if let key = key{
            AnyCancellable.release(key: key)
        }
    }
    
    var key:String? {
        for item in AnyCancellable.bag{
            if(item.value == self){
                return item.key
            }
        }
        return nil
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


public extension Publisher{
    func onReceive(_ block:@escaping (Output)->Void, key:String = #file, line:Int = #line){
        self.sink { error in } receiveValue: { value in
            block(value)
        }
        .retain(key, line: line)
    }
    
    func onReceiveCancellable(_ block:@escaping (Output, ()->Void)->Void, key:String = #file, line:Int = #line){
        
        self.sink { error in } receiveValue: { value in
            block(value, {
                AnyCancellable.release(key: getRetainKey(key: key, line: line))
            })
        }
        .retain(key, line: line)
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


public protocol CVSTransform {
    var cvs:CurrentValueSubject<Self, Never>{ get }
}

public extension CVSTransform {
    var cvs:CurrentValueSubject<Self, Never>{
        return CurrentValueSubject(self)
    }
}
