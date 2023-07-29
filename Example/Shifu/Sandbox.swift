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
    
    @State var items: [String] = ["Hello", "SwiftUI", "World", "This", "is",  "a", "flow", "layout"]
    var body: some View {
        SimpleFlowText(items: $items, onTap: { txt in
            clg(txt)
        })
        .padding()
    }
    
    func sandbox(){
        clg("OK==>")
    }
    
    
    
}




struct Sandbox_Previews: PreviewProvider {
    static var previews: some View {
        Sandbox()
    }
}
