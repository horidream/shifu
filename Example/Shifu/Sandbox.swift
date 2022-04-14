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
            SimpleMarkdownViewer(content: "## Hello World \n> Stay Hungry, Stay Foolish<br><p style='text-align: right; margin-right: 20px;'>—— Jobs</p>")
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
        
    }
}





