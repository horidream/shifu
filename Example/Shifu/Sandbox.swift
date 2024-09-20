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
    
    @StateObject var vm = ShifuWebViewModel()
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View {
        VStack{
            ShifuWebView(viewModel: vm)
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
        let arr = JSON.parse("@source/test.json".url?.content)
        vm.setCookies(arr)
        vm.url = "https://youtube.com".url
            
    }
    
    
    
    
    
}

final class Hero: NSObject, Buildable{
    var name: String?
    var age: Int?
}
