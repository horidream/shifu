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
    case `default`, linear, easeIn, easeOut, easeInOut, spring
}



public class ta<T:Equatable> {
    @Binding var target:T
    var currentAnimation: TweenAnimation<T>?
    let defaultDuration:Double = 0.35
    public init(_ target: Binding<T>){
        _target = target
    }
    
    func getAnimation(_ type:TweenAnimationType, duration: Double? = nil)-> Animation{
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
        default:()
        }
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
