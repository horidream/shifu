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


public struct SimpleMarkdownViewer: View{
    @StateObject public var viewModel:ShifuWebViewModel = .markdown
    var path: String
    public init(path : String){
        self.path = path
    }
    public var body: some View{
        MarkdownView(viewModel: viewModel,  content: .constant(path.url?.content ?? ""))
            .autoResize()
    }
}

@available(iOS 14.0, *)
public struct MarkdownView: View{
    @ObservedObject var viewModel:ShifuWebViewModel;
    @State var isMounted:Bool = false
    @Binding var content:String
    let markdownPageURL: URL? = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
    public init (viewModel:ShifuWebViewModel = ShifuWebViewModel{
        $0.allowScroll = true
        $0.url = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
    }, content:Binding<String>){
        self.viewModel = viewModel
        _content = content
        
    }
    
    public var body: some View{
        if(viewModel.url != markdownPageURL){
            viewModel.url = markdownPageURL
        }
        return ShifuWebView(viewModel: viewModel)
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
        if(viewModel.allowScroll){
            viewModel.allowScroll = false
        }
        return self
            .frame(minHeight: viewModel.contentHeight)
            .on("contentHeight", target: viewModel.delegate){
            if let height = $0.userInfo?["value"] as? CGFloat, height != viewModel.contentHeight {
                self.viewModel.contentHeight = height
            }

        }
    }
    
    public func updateContent(){
        viewModel.apply("m.vm.content = content", arguments: ["content": content ])
    }
}





extension Notification.Name{
    static var mounted = "mounted".toNotificationName()
}



@available(iOS 14.0, *)
public extension ShifuWebViewModel{
    func html2md(_ html:String, callback: @escaping (String?)->Void){
        guard delegate?.webView.title == "Markdown" else {
            callback(nil)
            return
        }
        
        apply("return toMarkdown(html)", arguments: ["html": html]) {
            switch $0{
            case .success(let result):
                if let result = result as? String{
                    callback(result)
                }else{
                    callback(nil)
                }
            default: callback(nil)
            }
        }
    }
}

