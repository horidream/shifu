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
    @Binding var content:String
    let markdownPageURL: URL? = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
    public init (viewModel:ShifuWebViewModel = ShifuWebViewModel{
        $0.allowScroll = true
        $0.url = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
    }, content:Binding<String>){
        self.viewModel = viewModel
        _content = content
        
    }
    
    
    public func transforom(html:String?,  callback: @escaping (String?)->()){
        "onMarkdown".toNotificationPublisher(of: viewModel.delegate)
            .first()
            .sink { notification in
                if let md = notification.userInfo?["value"] as? String{
                    callback(md)
                }
                callback(nil)
            }
            .retain()
            
            
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
        viewModel.delegate?.exec(script: #"m.vm.content = "\#(content.normalized)""#)
    }
}





extension Notification.Name{
    static var mounted = "mounted".toNotificationName()
}





