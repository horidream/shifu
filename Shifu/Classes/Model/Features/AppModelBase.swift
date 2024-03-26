//
//  AppModelBase.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 13.0, *)
public protocol AppModelBase: AnyObject {
    var appName:String { get }
    var version:String { get }
    var isPad:Bool { get }
    var isPhone: Bool {  get }
    var ext:[ String:Any] {  get set  }
    func getProperty<T>(_ key:String, fallback:@autoclosure ()->T)->T
    func setProperty<T>(_ key:String, value:T)
}





private struct Keys {
    static var extKey = "extKey"
}

public extension AppModelBase {
    var ext: [String: Any] {
        set {
            objc_setAssociatedObject(self, &Keys.extKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &Keys.extKey) as? [String: Any] ?? [:]
        }
    }
    
    func getProperty<T>(_ key:String, fallback:@autoclosure ()->T)->T{
        if let value = ext[key] as? T {
            return value
        } else {
            let fallbackValue = fallback()
            ext[key] = fallbackValue
            return fallbackValue
        }
    }
}


@available(iOS 13.0, *)
public extension AppModelBase where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher{
    
    var version:String {
        get{ 
            getProperty("version",  fallback: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "UNKNOWN") as! String)
        }
    }
    var appName:String {
        get{
            getProperty("appName", fallback:Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String)
        }
    }
    var isPad:Bool {
        get{
            getProperty("isPad", fallback:UIDevice.current.userInterfaceIdiom == .pad)
        }
    }
    var isPhone:Bool {
        get{
            getProperty("isPhone", fallback:UIDevice.current.userInterfaceIdiom == .phone)
        }
    }
    
    var language: String{
        get {
            getProperty("language", fallback: Locale.current.languageCode ?? "en")
        }
    }
    
    func setProperty<T>(_ key:String, value:T) where T:Equatable{
        if ext[key] as? T !=  value {
            objectWillChange.send()
            ext[key] = value
        }
    }
    
    func setProperty<T>(_ key:String, value:T) {
        objectWillChange.send()
        ext[key] = value
    }
}
