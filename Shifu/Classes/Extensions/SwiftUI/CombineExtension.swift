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

public protocol Retainable{
    associatedtype RetainReference:Equatable
    static var bag:[AnyHashable: [RetainReference]] { get set }
    func retain(_ key: AnyHashable, line: Int, overwrite:Bool) -> Self
    static func release(key:AnyHashable)
}

public extension Retainable{
    @discardableResult func retainSingleton(_ key: AnyHashable = #file, line: Int = #line) -> Self {
        retain(key, line: line, overwrite: true)
    }
    
    @discardableResult func retain(_ key: AnyHashable = #file, line: Int = #line, overwrite:Bool = false) -> Self {
        let key = getRetainKey(key: key, line: line)
        if let this = self as? RetainReference{
            if overwrite {
                Self.bag[key] = [this]
            } else {
                if Self.bag[key] == nil {
                    Self.bag[key] = []
                }
                Self.bag[key]?.append(this)
            }
        }
        return self
    }
    
    static func release(key:AnyHashable){
//        Self.bag[key]?.removeAll()
        Self.bag.removeValue(forKey: key)
    }
    
}

@available(iOS 13.0, *)
extension AnyCancellable: Retainable{
    public static var bag:[AnyHashable:[AnyCancellable]] = [:]
}

extension NSKeyValueObservation: Retainable{
    public static var bag:[AnyHashable: [NSKeyValueObservation]] = [:]
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



public protocol SubjectTransformable {
    var cvs:CurrentValueSubject<Self, Never>{ get }
    var ps:PassthroughSubject<Self, Never>{ get }
}

public extension SubjectTransformable {
    var cvs:CurrentValueSubject<Self, Never>{
        return CurrentValueSubject(self)
    }
    var ps:PassthroughSubject<Self, Never>{
        return PassthroughSubject()
    }
}

extension String: SubjectTransformable{}
extension Int: SubjectTransformable{}

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


public protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    public func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}

public struct UIControlPublisher<Control: UIControl>: Publisher {

    public typealias Output = Control
    public typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

final class UIControlSubscription<SubscriberType: Subscriber,
                                  Control: UIControl>: Subscription
                                  where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}
