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
import ShifuLottie





struct Sandbox:View{
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    var body: some View {
        VStack{
            Image(.arrowDownMessageFill)
                .foregroundStyle(.blue)
                .font(.system(size: 100).bold())
                .shadow(radius: 1, x: 3, y: 3)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        let a = UserDefaults.standard.string(forKey: "userPreferredLanguage")  ??  "zh_CN"
        clg(a)
    }
    
    
}

