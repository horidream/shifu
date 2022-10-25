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


@propertyWrapper
public struct Proxy<EnclosingSelf, Value> {
    private let keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>
    private let target:EnclosingSelf
    public init(_ target:EnclosingSelf, _ keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>) {
        self.target = target
        self.keyPath = keyPath
        
        
    }
    
    public var wrappedValue: Value {
        get { target[keyPath: keyPath] }
        set { target[keyPath: keyPath] = newValue }
    }
    
}
