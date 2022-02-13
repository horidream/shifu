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
    @State var isMounted:Bool = false
    @Binding var content:String
    @State var script:String?
    public init (content:Binding<String>){
        _content = content
    }
    
    public var body: some View{
        return
        ShifuWebView(script: $script, url: .constant(Shifu.bundle.url(forResource: "web/index", withExtension: "html")))
            .onChange(of: content) { _ in
                if(isMounted){
                    updateContent()
                }
            }
            .on(.MOUNTED){ _ in
                updateContent()
                isMounted = true
            }
    }
    
    public func updateContent(){
        clg("will update content \(content)")
        script = #"m.vm.content = "\#(content.normalized)""#
    }
}





extension Notification.Name{
    static var mounted = "mounted".toNotificationName()
}




