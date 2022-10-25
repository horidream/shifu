//
//  Config.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Shifu

let clg = Shifu.clg(prefix: ">")
let localized = Shifu.localizer()

class Test{
    func say()->String{
        "hello"
    }
}

struct Person: Codable{
    let name:String
    let age:Int
}

class Theme{
    @ThemedColor(light: .red, dark: .white)
    public static var iconColor
    @ThemedColor(light: .gray, dark: .white)
    public static var titlePrimary
    @ThemedColor(light: .darkGray, dark: .lightGray)
    public static var titleSecondary
}
//
//  PersistToFile2.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/25.
//

import SwiftUI



@propertyWrapper public class Persist<T:Codable>{
    private var _value:T
    private var url:URL?


    
    public var wrappedValue:T{
        get{
            return _value
        }
        set{
            do{
                if let str = newValue.stringify(), let url{
                    try str.write(to: url, atomically: true, encoding: .utf8)
                }
                _value = newValue
            }catch{
                clg(error)
            }
        }
    }
    
    public var projectedValue: Binding<T>{
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    public init(wrappedValue: T, _ path: String){
        url = (path.starts(with: "@") ? path.url : "@documents/\(path)".url)
        let str = url?.content ?? ""
        _value = str.parse(to: T.self) ?? wrappedValue
    }
}
