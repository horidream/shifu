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

public struct MarkdownView: View{
    @ObservedObject var viewModel:ShifuWebViewModel;
    @State var isMounted:Bool = false
    @State var script:String?
    
    @Binding var content:String
    @State var allowScroll:Bool = true
    @State var webView:ShifuWebView?
    public init (viewModel:ShifuWebViewModel = ShifuWebViewModel(), content:Binding<String>, allowScroll:Bool = true){
        self.viewModel = viewModel
        _content = content
        _allowScroll = State(initialValue: allowScroll)

        
    }
    
    
    public var body: some View{
        ShifuWebView(viewModel: viewModel, script: $script, url: .constant(Shifu.bundle.url(forResource: "web/index", withExtension: "html")), allowScroll: $allowScroll)
            .environmentObject(viewModel)
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
    
    public func autoResize()-> some View{
        self
            .frame(minHeight: viewModel.contentHeight)
            .on("contentHeight", target: viewModel.id){
            if let height = $0.userInfo?["value"] as? CGFloat{
                self.viewModel.contentHeight = height
            }
                
        }
    }
    
    public func updateContent(){
        script = #"m.vm.content = "\#(content.normalized)""#
    }
}





extension Notification.Name{
    static var mounted = "mounted".toNotificationName()
}





