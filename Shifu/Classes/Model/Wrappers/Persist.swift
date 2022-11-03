//
//  PersistToFile2.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/25.
//

import SwiftUI

@propertyWrapper public struct Persist<T:Codable>: DynamicProperty{
    @State private var value:T
    private var url:URL?
    
    public var wrappedValue:T{
        get{
            return value
        }
        nonmutating set{
            do{
                if let str = newValue.stringify(), let url{
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    value = newValue
                }
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
        _value = State(wrappedValue: str.parse(to: T.self) ?? wrappedValue)
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
