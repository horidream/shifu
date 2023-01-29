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



struct PopoverDemo: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var vm = ShifuWebViewModel()
    @State var shouldShowPopover = false
    var body: some View {
        VStack{
            Button{
                shouldShowPopover.toggle()
            } label: {
                Text("Click Me")
            }
            .shifuPopover(isPresented: $shouldShowPopover, arrowDirection: .down) {
                VStack{
                    Button{
                        vm.html =  """
        <style>
        body{
            background: purple;
            display: flex;
            justify-content: center;
            flex-direction: column;
            align-items: center;
            color: white;
        }
        </style>
        <h2>YES</h2>
        """
                    } label: {
                        Text("Update Webview")
                    }
                    .padding()
                    
                    ShifuWebView(viewModel: vm)
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .onAppear {
            sandbox()
        }
        .onInjection {
            sandbox()
        }
        
    }
    
    func sandbox() {
        vm.html = """
        <style>
        body{
            background: purple;
            display: flex;
            justify-content: center;
            flex-direction: column;
            align-items: center;
            color: white;
        }
        </style>
        <h2>Hori!</h2><p>There is a good example</p>
        """
        vm.publisher(of: "hi")
            .sink { notification in
                clg(notification.userInfo?["name"] ?? "")
            }
            .retainSingleton()
        clg("我"*3) // 我我我我我我我我我我我我)
        vm.apply("""
        postToNative({type:"hi", name: "Leon"});
        return postToNative.toString();
        """)
    }
    
}


