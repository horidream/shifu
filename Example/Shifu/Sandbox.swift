//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
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

struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var isLegacySplitView = false
    @MutablePersist("shouldShowNaivigationBar") var shouldShowNaivigationBar:Bool = true
    @State var arr = ["1","2","3"]
    var body: some View {
        ShifuSplitView(data: $arr) { i in
            Text(i)
        } detail: { selected in
            
            switch selected {
            case "1":
                ZStack{
                    Toggle("Force Legacy", isOn: $isLegacySplitView)
                    ShifuPasteButton(view: {
                        Image(.paste, size: 34)
                    }, onPaste: { items in
                        clg(items)
                    }, config: { config in
                        config.forceLegacy = isLegacySplitView
                    })
                }
                .padding()
            default:
                Text("You selecrted \(selected ?? "nothing" )")
            }
        } config: { config in
            config.navigationTitle = Text("Hello")
            config.navigationBarTitleDisplayMode = .automatic
            config.navigationBarHidden = (!shouldShowNaivigationBar, !shouldShowNaivigationBar)
        }
        .navigationBarHidden(shouldShowNaivigationBar)
        .navigationTitle("ShifuSplitView Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                Toggle("Show Navigation Bar", isOn: $shouldShowNaivigationBar)
            }
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        
        
    }
    func sandbox(){
        clg( 1..<10 ~= 1)
        
    }
    
}


