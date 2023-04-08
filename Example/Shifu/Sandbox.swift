//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/2.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import ShifuWebServer
import UniformTypeIdentifiers
import CoreServices
import Combine
import PencilKit
import SwiftSoup
import VisionKit
import AVKit
import WebKit



struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var content = "# hello"
    @State var isOn = true
    var body: some View {
    
        Text("Sandbox")
            .onInjection{
                sandbox()
            }
            .onAppear{
                sandbox()
            }
    }
    
    func sandbox(){
        clg("OK")
    }
    
    
    
}

