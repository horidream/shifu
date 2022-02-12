//
//  MarkDownView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/10.
//

import Foundation
import SwiftUI
import UIKit
import WebKit
import Combine

public struct MarkDownView: View{
    @Binding var content:String
    @State var script:String?
    public init (content:Binding<String>){
        _content = content
    }
    
    public var body: some View{
        return
        ShifuWebView(script: $script, url: .constant(Shifu.bundle.url(forResource: "web/index", withExtension: "html")))
            .onChange(of: content) { newValue in
                script = #"m.vm.content = "\#(newValue.normalized)""#
            }
    }
}





extension Notification.Name{
    static var mounted = "mounted".toNotificationName()
}




