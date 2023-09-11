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
    @StateObject var app = WebServer()
    @State var url =  "http://localhost:9999".url!
    @State var shouldShowPage = false;
    var body: some View {
        VStack{
            ShifuWebView(url: url)
                    .autoResize()
                    .border(.green, width: 1)
        }
        .padding()
        .onAppear(){
            sandbox()
        }
        .onInjection {
            sandbox()
        }
        .onDisappear(){
            app.stopServer()
        }
        
        
    }
    
    func sandbox(){
        app.useStatic("@/web")
        app.post("/") { req in
            return .json(["a": 222])
        }
        app.get("/abc/*") { req in
            if let a = req.path.match(/\/abc\/(.*)/){
                return .text("You are requesting `abc` with \(a.1)")
            }
            return .res404
        }
        app.server.addHandler { method, url, headers, path, query in
            if path.starts(with: "/baoli"){
                return GCDWebServerRequest(method: method, url: url, headers: headers, path: path, query: query)
            } else {
                return nil
            }

        } processBlock: { req in
            return .text("default")
        }

        app.startServer(port: 9999)
    }
    
    
    
    
    
}


//
//
//struct Sandbox_Previews: PreviewProvider {
//    static var previews: some View {
//        Sandbox()
//    }
//}


class WebServer: ObservableObject, AppModelBase, AppModelWeb{
    init(){
        self.initServer()
    }
}
