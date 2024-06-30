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
import GCDWebServer




struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View {
        VStack{
            Text("Hello!!++>>>")
        }
        .padding()
        .onAppear(){
            sandbox()
        }
        .onInjection {
            sandbox()
        }
        
    }
    
    
    
    func sandbox(){

        clg("@source/test.json".fileContent?["name"])

    }
    
    
    
    
    
}

