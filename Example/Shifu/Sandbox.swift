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
    @State var shouldShowPopover = false
    var body: some View {
        Button{
            shouldShowPopover.toggle()
        } label: {
            Text("Click Me")
        }
        .popover(isPresented: $shouldShowPopover, arrowEdge: .top) {
            
            ShifuWebView(viewModel: vm)
                .ignoresSafeArea()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)

            .onInjection {
                sandbox()
            }
            .onAppear {
                sandbox()
            }
        
    }
    
    func sandbox() {
        vm.html = """
        <style>
        body{
            background: yellow;
        }
        </style>
        <h2>Hi</h2><p>hihihihi</p>
        """
        vm.publisher(of: "hi")
            .sink { notification in
                clg(notification.userInfo?["name"])
            }
            .retainSingleton()
        vm.apply("""
        return postToNative.toString();
        """){ rst in
            clg(rst)
        }
    }
    
}

