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
import UIKit

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    var c = CurrentValueSubject<[(AnyDiffableData, [AnyDiffableData])], Never>([])
    var body: some View{
        Text("hello world")
            .onTapGesture {
                c.value.append(("Hello", []))
            }
            .onInjection{
                sandbox()
            }
//            .onReceive(c){
//                clg($0)
//            }
            .onAppear{
                sandbox()
            }
    }
    
    
    func sandbox(){
        

        
        
    }
}


