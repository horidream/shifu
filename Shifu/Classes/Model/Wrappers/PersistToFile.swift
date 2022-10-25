//
//  Persist.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/7/30.
//

import Foundation
import SwiftUI

@propertyWrapper public struct PersistToFile:DynamicProperty{
    @State private var value = ""
    private var url:URL!


    
    public var wrappedValue:String{
        get{
            return value
        }
        nonmutating set{
            do{
                try newValue.write(to: url, atomically: true, encoding: .utf8)
                value = newValue
            }catch{
                clg(error)
            }
        }
    }
    
    public var projectedValue: Binding<String>{
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    public init(_ path:String){
        url = (path.starts(with: "@") ? path.url : "@documents/\(path)".url)
        guard url != nil else { return } 
        let initialText = (try? String(contentsOf: url)) ?? ""
        _value = State(wrappedValue: initialText)
    }
}

