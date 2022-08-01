//
//  CombineExtension.swift
//  ClipboardComposer
//
//  Created by Baoli Zhai on 2021/3/6.
//

import Combine
import UIKit
import SwiftUI

fileprivate func getRetainKey(key:AnyHashable, line:Int)->AnyHashable{
    if let key = key as? String, key.hasSuffix(".swift"){
        return "\(key)-\(line)"
    }else{
        return key
    }
}

@available(iOS 13.0, *)
public extension AnyCancellable{
    static var bag:[AnyHashable:AnyCancellable] = [:]
    @discardableResult func retain(_ key: AnyHashable = #file, line: Int = #line) -> Self {
        AnyCancellable.bag[getRetainKey(key: key, line: line)] = self
        return self
    }
    
    
    
    func release(){
        if let key = key{
            AnyCancellable.release(key: key)
        }
    }
    
    var key:AnyHashable? {
        for item in AnyCancellable.bag{
            if(item.value == self){
                return item.key
            }
        }
        return nil
    }
    
    static func release(key:AnyHashable){
        bag[key]?.cancel()
        AnyCancellable.bag.removeValue(forKey: key)
    }
    
    static func releaseAll(test:((AnyHashable)->Bool) = { _ in true }){
        
        bag.keys.filter(test).forEach { (key) in
            release(key: key)
        }
    }
    static func releaseAll(pattern: String){
        bag.keys.compactMap{ $0 as? String }.filter({ $0.range(of: pattern, options: .regularExpression) != nil }).forEach { (key) in
            release(key: key)
        }
    }
}


public extension Publisher{
    func onReceive(_ block:@escaping (Output)->Void, key: @autoclosure ()-> String = #file + "\(#line)"){
        self.sink { error in } receiveValue: { value in
            block(value)
        }
        .retain(key())
    }
    
    func onReceiveCancellable(_ block:@escaping (Output, ()->Void)->Void, key: @autoclosure ()-> String = #file + "\(#line)"){
        let myKey = key()
        self.sink { error in } receiveValue: { value in
            block(value, {
                AnyCancellable.release(key: myKey)
            })
        }
        .retain(myKey)
    }
}

//@available(iOS 13.0, *)
//public func debounce<T>(_ id:AnyHashable, closure:@escaping (T)->Void)->((T)->Void){
//    
//    let publisher = PassthroughSubject<T, Never>()
//    publisher.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//       .sink{
//           i in
//           closure(i)
//       }.retain(id)
//    return publisher.send
//}
//
//@available(iOS 13.0, *)
//public func debounce(_ id:AnyHashable, closure:@escaping ()->Void)->(()->Void){
//    
//    let publisher = PassthroughSubject<Void, Never>()
//    publisher.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//       .sink{ _ in
//           closure()
//       }.retain(id)
//    return publisher.send
//}


public protocol CVSTransform {
    var cvs:CurrentValueSubject<Self, Never>{ get }
}

public extension CVSTransform {
    var cvs:CurrentValueSubject<Self, Never>{
        return CurrentValueSubject(self)
    }
}


public extension NSKeyValueObservation{
    static var bag:[AnyHashable:NSKeyValueObservation] = [:]
    @discardableResult func retain(_ key: @autoclosure ()-> AnyHashable = #file + "\(#line)" ) -> Self {
        NSKeyValueObservation.bag[key()] = self
        return self
    }



    func release(){
        if let key = key{
            NSKeyValueObservation.release(key: key)
        }
    }

    var key:AnyHashable? {
        for item in NSKeyValueObservation.bag{
            if(item.value == self){
                return item.key
            }
        }
        return nil
    }

    static func release(key:AnyHashable){
        NSKeyValueObservation.bag.removeValue(forKey: key)
    }

    static func releaseAll(test:((AnyHashable)->Bool) = { _ in true }){
        bag.keys.filter(test).forEach { (key) in
            release(key: key)
        }
    }
    
    static func releaseAll(pattern: String){
        bag.keys.compactMap{ $0 as? String }.filter({ $0.range(of: pattern, options: .regularExpression) != nil }).forEach { (key) in
            release(key: key)
        }
    }
}


extension NSKeyValueObservedChange{
    public func release(key: AnyHashable){
        NSKeyValueObservation.release(key: key)
    }
}

public class ObservableArray<T:ObservableObject>: ObservableObject {

    @Published private(set) public var list:[ObservedObject<T>] = [] {
        didSet{
            cancellables = []
            list.forEach({
                let c = $0.wrappedValue.objectWillChange.sink(receiveValue: { _ in self.objectWillChange.send() })
                self.cancellables.append(c)
            })
            
        }
    }
    var cancellables = [AnyCancellable]()

    public init(_ array: T...) {
        self.list = array.map{ ObservedObject(wrappedValue: $0) }
    }
    
    public init(_ array: [T]) {
        self.list = array.map{ ObservedObject(wrappedValue: $0) }
        
    }
    

    public func wrapper(at index:Int)->ObservedObject<T>.Wrapper?{
        return list.get(index)?.projectedValue
    }
    
    public func value(at index:Int)->T?{
        return list.get(index)?.wrappedValue
    }

}
