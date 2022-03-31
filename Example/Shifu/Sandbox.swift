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
    var body: some View{
        VStack(){
            SimpleMarkdownViewer(content: "## Hello World \n> Stay Hungry, Stay Foolish")
                .padding()
                
//                .background(.yellow)
            Circle()
                .foregroundColor(.red)
//                .background(.green)
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
        clg(Test().stringify()?.parse(to: Test.self)?.color.alpha)
    }
}

class Test:Codable{
    @CodableColor public var color = .red.withAlphaComponent(0.3)
}



