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
    public init (viewModel:ShifuWebViewModel = ShifuWebViewModel(), content:Binding<String>, allowScroll:Bool = true){
        self.viewModel = viewModel
        _content = content
        _allowScroll = State(initialValue: allowScroll)
    }
    
    
    public var body: some View{
        
        return
        ShifuWebView(viewModel: viewModel, script: $script, url: .constant(Shifu.bundle.url(forResource: "web/index", withExtension: "html")), allowScroll: $allowScroll)
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




protocol MarkdownViewModifer {
    associatedtype Body: View
    func body(_ webView: MarkdownView) -> Body
}

struct AutoResizableModifier: MarkdownViewModifer {
    @Binding var contentHeight:CGFloat
    func body(_ webView: MarkdownView) -> some View {
        return webView
            .on("contentHeight"){
                if let height = $0.userInfo?["value"] as? CGFloat, let vc = $0.object as? ShifuWebViewController, vc.webView.title == "Markdown"{
                    self.contentHeight = height
                }
            }
            .frame(minHeight: contentHeight)
    }
}

extension MarkdownView{
    func modifier<M: MarkdownViewModifer>(_ theModifier: M) -> some View {
        return theModifier.body(self)
    }
}

public extension MarkdownView{
    public func autoResize(_ contentHeight:Binding<CGFloat>) -> some View{
        self.modifier(AutoResizableModifier(contentHeight: contentHeight))
    }
}

