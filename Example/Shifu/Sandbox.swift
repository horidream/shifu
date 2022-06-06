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
    var body: some View{
        Text("hello")
            .onInjection{
                sandbox()
            }
            .onAppear{
                sandbox()
            }
    }
    
    
    func sandbox(){
        
        
        struct Features: OptionSet {
            let rawValue: Int
            
            static let feature1   = Features(rawValue: 1 << 0)
            static let feature2   = Features(rawValue: 1 << 1)
            static let feature3   = Features(rawValue: 1 << 2)
            static let extra      = Features(rawValue: 1 << 3)
            
            static let standard: Features = [.feature1, .feature2]
            static let premium: Features = [standard, .feature3, .extra]
        }
        print(Features.premium.contains(.extra)) // true
        print(Features.premium.rawValue) // 15
        
    }
}


