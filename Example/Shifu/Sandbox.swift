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
import MobileCoreServices
import UniformTypeIdentifiers



struct Sandbox:View{
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = "Hello"
    @PersistToFile("a.txt") var n:String
    let layout = [GridItem(.adaptive(minimum: 60))]
    var body: some View {
        VStack{
            Text(text)

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
        clg("hello world")
    }
    
    
}





