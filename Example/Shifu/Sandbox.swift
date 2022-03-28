//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        ScrollView(.vertical, showsIndicators: false) {
            
        }
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



