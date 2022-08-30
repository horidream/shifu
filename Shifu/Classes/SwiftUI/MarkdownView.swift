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

fileprivate func getConfiguration(script:String?, css:String?)->String?{
    guard script ?? css != nil else { return nil }
    var rst = script ?? ""
    if let css = css{
        rst += """
var __style = document.createElement('style');
__style.innerHTML = '\(css)';
document.head.appendChild(__style);
"""
    }
    return rst
    
}

public struct SimpleMarkdownViewer: View{
    @StateObject public var viewModel:ShifuWebViewModel
    var path: String?
    var content: String?
    var animated: Bool
    var stringContent:String{
        content ?? path?.url?.content ?? ""
    }
    
    public init(path : String, animated: Bool = true, postScript:String? = nil, css:String? = nil){
        self.path = path
        self.animated = animated
        _viewModel = StateObject(wrappedValue: with(.markdown){
            $0.configuration = getConfiguration(script: postScript, css: css)
        })
    }
    
    public init(content: String, animated:Bool = true, postScript:String? = nil, css:String? = nil){
        self.content = content
        self.animated = animated
        _viewModel = StateObject(wrappedValue: with(.markdown){
            $0.configuration = getConfiguration(script: postScript, css: css)
        })
    }
    
    public var body: some View{
        MarkdownView(viewModel: viewModel,  content: .constant(stringContent))
            .autoResize(animated)
//            .if(animated){
//                $0.animation(.none, value: viewModel.contentHeight)
//                    .scaleEffect(viewModel.contentHeight == 0 ? 0.973 : 1, anchor: .top)
//                    .opacity(viewModel.contentHeight == 0 ? 0 : 1)
//                    .animation(.default, value: viewModel.contentHeight)
//            }
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
    
    public func autoResize(_ animated: Bool = true)-> some View{
        if(viewModel.allowScroll){
            viewModel.allowScroll = false
        }
        return self
            .frame(height: viewModel.contentHeight)
            .on("contentHeight", target: viewModel.delegate){
                if let height = $0.userInfo?["value"] as? CGFloat, height != viewModel.contentHeight {
                    withAnimation(.easeIn) {
                        self.viewModel.contentHeight = height
                        
                    }
                    
                }
            }
            .if(animated){
                $0.animation(.none, value: viewModel.contentHeight)
                    .scaleEffect(viewModel.contentHeight == 0 ? 0.973 : 1, anchor: .top)
                    .opacity(viewModel.contentHeight == 0 ? 0 : 1)
                    .animation(.default, value: viewModel.contentHeight)
            }
    }
    
    public func apply(_ funtionBody:String, arguments:[String: Any] = [:], callback: ((Result<Any, Error>) -> Void)? = nil)-> MarkdownView{
        viewModel.apply(funtionBody, arguments: arguments, callback: callback)
        return self
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

