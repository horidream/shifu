//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var content = ""
    var body: some View{
        VStack(){
            SimpleMarkdownViewer(content: content)
                .id(content)
                .padding()
            
            Spacer()

        }
        .navigationTitle("Sandbox")
        .onInjection {
            sandbox()
        }
        .onAppear{
            sandbox()
            
        }
    }
    
    func sandbox(){
        content = "## Sandbox\n> This is the `way`."
        let i1 = Item(name: "OK", price: 99)
        let i2 = Item(name: "OK", price: 99)
        
        clg(i1.hashValue == i2.hashValue, i1 == i2)
        
        var hasher = Hasher()
        hasher.combine("OK")
        clg(i1.hashValue, hasher.finalize())
    }
}


struct Item: Hashable, Equatable {
    static func == (lhs: Item, rhs: Item)->Bool{
        return lhs.hashValue == rhs.hashValue
    }
    var name:String
    var price:Double
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
//        hasher.combine(price)
    }
}
