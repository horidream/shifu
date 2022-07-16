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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
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
        clg("👍".applyingTransform(StringTransform("Hex/Unicode"), reverse: false)!) // U+1F44D
    }
    
    
}

