//
//  TweenAnimation.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/15.
//

import Foundation
import SwiftUI

public class TweenAnimation<T:Equatable>{
    @Binding var value:T
    let startValue:T
    let endValue:T
    let animation:Animation
    @discardableResult public init(_ value: Binding<T>, from: T? = nil, to: T? = nil, animation: Animation = .default ){
        _value = value
        startValue = from ?? value.wrappedValue
        endValue = to ?? value.wrappedValue
        self.animation = animation
    }
    
    @discardableResult public func play(delay: Double = 0)->TweenAnimation{
        guard startValue != endValue else { return self }
        withAnimation(animation.delay(delay)) {
            if (value != startValue) {
                withAnimation(.linear(duration: 0)){
                    value = startValue
                }
            }
            value = endValue
        }
        return self
    }
    
}


public enum TweenAnimationType{
    case `default`, linear, easeIn, easeOut, easeInOut, spring, back, custom(Animation)
    
    public var raw:Animation {
        return getAnimation(self)
    }
}



public class ta<T:Equatable> {
    @Binding var target:T
    var currentAnimation: TweenAnimation<T>?

    public init(_ target: Binding<T>){
        _target = target
    }
    
    @discardableResult public func delay(_ delay: Double)->ta<T>{
        currentAnimation?.play(delay: delay)
        return self
    }
    
    @discardableResult public func to(_ value: T, duration: Double? = nil, type: TweenAnimationType = .default)->ta<T>{
        currentAnimation =  TweenAnimation($target, to: value, animation: getAnimation(type, duration: duration)).play()
        return self
    }
    
    @discardableResult public func from(_ value: T, duration: Double? = nil, type: TweenAnimationType = .default)->ta<T>{
        currentAnimation = TweenAnimation($target, from: value, animation: getAnimation(type, duration: duration)).play()
        return self
    }
    
    @discardableResult public func from(_ value: T, to:T,  duration: Double? = nil, type: TweenAnimationType = .default)->ta<T>{
        currentAnimation = TweenAnimation($target, from: value, to: to, animation: getAnimation(type, duration: duration)).play()
        return self
    }
}

let defaultDuration:Double = 0.35
private func getAnimation(_ type:TweenAnimationType, duration: Double? = nil)-> Animation{
    switch type{
    case .default:
        if let duration = duration{
            return .linear(duration: duration)
        }
        return .default
    case .linear:
        if let duration = duration, duration != defaultDuration{
            return .linear(duration: duration)
        }else{
            return .linear
        }
    case .easeIn:
        if let duration = duration, duration != defaultDuration{
            return .easeIn(duration: duration)
        }else{
            return .easeIn
        }
    case .easeOut:
        if let duration = duration, duration != defaultDuration{
            return .easeOut(duration: duration)
        }else{
            return .easeOut
        }
    case .easeInOut:
        if let duration = duration, duration != defaultDuration{
            return .easeInOut(duration: duration)
        }else{
            return .easeInOut
        }
    case .spring:
        if let duration = duration, duration != defaultDuration{
            return .spring().speed(defaultDuration / duration)
        }else{
            return .spring()
        }
    case .back:
        var d = duration ?? defaultDuration
        var speed = d <= 0 ? 100 : defaultDuration/d
        return .interpolatingSpring(stiffness: 200, damping: 15)
            .speed(speed)
    case .custom(let animation):
        return animation
    default:()
    }
}


public class TweenProps: ObservableObject{
    public init() {}
    @Published public var rotation:Double = .zero
    @Published public var rotationX:Double = .zero
    @Published public var rotationY:Double = .zero
    @Published public var rotationZ:Double = .zero
    @Published public var scale:Double = 1 {
        didSet {
            scaleX = scale
            scaleY = scale
        }
    }
    @Published public var scaleX:Double = 1
    @Published public var scaleY:Double = 1
    @Published public var alpha:Double = 1
    @Published public var x:Double = 0
    @Published public var y:Double = 0
    @Published public var color: Double = 0
    @Published public var blur: Double = 0
}

public extension View{
    func tweenProps(_ props: TweenProps)->some View{
        return self.modifier(TweenModifier(props: props))
    }
}

struct TweenModifier:ViewModifier{
    @ObservedObject var props:TweenProps = TweenProps()
    
    func body(content: Content) -> some View {
        
        return content
            .offset(x: props.x.cgFloat, y: props.y.cgFloat)
            .scaleEffect(x: props.scaleX, y: props.scaleY)
            .rotationEffect(Angle(degrees: props.rotation))
            .opacity(props.alpha)
            .blur(radius: props.blur, opaque: false)
            .rotation3DEffect(Angle(degrees: props.rotationX), axis: (1, 0, 0))
            .rotation3DEffect(Angle(degrees: props.rotationY), axis: (0, 1, 0))
            .rotation3DEffect(Angle(degrees: props.rotationZ), axis: (0, 0, 1))
            .foregroundColor(Color(UInt(props.color)))
    }
}

public func tween(_ target:ObservedObject<TweenProps>.Wrapper,
                  from :[PartialKeyPath<ObservedObject<TweenProps>.Wrapper> : any TweenableValue] = [:],
                  to: [PartialKeyPath<ObservedObject<TweenProps>.Wrapper> : any TweenableValue] = [:],
                  duration: Double? = nil,
                  delay: Double = 0,
                  type: TweenAnimationType = .default){
    var arr = [(Binding<Double>, Double)]()
    withAnimation(getAnimation(type, duration: duration).delay(delay)) {
        withAnimation(.linear(duration: 0)){
            for item in from{
                guard let prop = target[keyPath: item.key] as? Binding<Double> else { continue }
                arr.append((prop, prop.wrappedValue))
                if let value = item.value as? Double{
                    prop.wrappedValue = value
                } else if let value = item.value as? String{
                    prop.wrappedValue = prop.wrappedValue + value.double
                }
            }
        }
        for item in arr{
            item.0.wrappedValue = item.1
        }
        for item in to{
            guard let prop = target[keyPath: item.key] as? Binding<Double> else { continue }
            if let value = item.value as? Double{
                prop.wrappedValue = value
            } else if let value = item.value as? String{
                prop.wrappedValue = prop.wrappedValue + value.double
            }
        }
    }
}

public protocol TweenableValue: Equatable{
    var double: Double { get }
}

extension Double: TweenableValue {
    public var double: Double {
        return self
    }
}
extension String: TweenableValue {
    public var double: Double {
        return Double(self) ?? 0
    }
}


