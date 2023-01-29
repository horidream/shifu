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



struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View {
        Text("hello")
        .onInjection {
            sandbox()
        }
        .onAppear {
            sandbox()
        }
        
    }
    
    func sandbox() {
        
    }
    
}



