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
    @StateObject var vm = ShifuWebViewModel()
    var body: some View {
        
        ShifuWebView(viewModel: vm)
            .onInjection {
                sandbox()
            }
            .onAppear {
                sandbox()
            }
        
    }
    
    func sandbox() {
        vm.html = """
        <h2>Hi</h2><p>hihihi</p>
        """
        clg(vm.isLoading)
        vm.apply("""
        document.getElementsByTagName("h2")[0].innerHTML = Baoli;
        console.log(document.body.innerHTML);
        
        """, arguments: ["Baoli": "Horidream"])
    }
    
}

