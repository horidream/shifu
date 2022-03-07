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


@available(iOS 13.0, *)
public extension AppModelBase where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher{

    var version:String {
        get{ getProperty("version",  fallback: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "UNKNOWN") as! String)
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
    
    
    
    func getProperty<T>(_ key:String, fallback:@autoclosure ()->T)->T{
        if ext[key] != nil, let instance = ext[key] as? T {
            return instance
        }else{
            let instance =  fallback()
            ext[key] = instance
            return instance
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


