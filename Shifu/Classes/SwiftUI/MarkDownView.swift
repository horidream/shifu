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

public struct MarkDownView: UIViewControllerRepresentable{
    @Binding var script:String
    public init (script:Binding<String>){
        _script = script
    }
    
    public func makeUIViewController(context: Context) -> ShifuWebViewController {
        
        return ShifuWebViewController{
            $0.url = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
        }
    }
    
    public func updateUIViewController(_ uiViewController: ShifuWebViewController, context: Context) {
        if !script.isEmpty{
            uiViewController.exec(script: script)
        }
    }
    
    public typealias UIViewControllerType = ShifuWebViewController
    
    
}


protocol Buildable{
    init(builder: (Self)->Void)
}

extension Buildable where Self:UIViewController {

    init(builder: (Self)->Void){
        self.init()
        builder(self)
    }
    
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Notification.Name{
    static var mounted = "mounted".toNotificationName()
}

final public class ShifuWebViewController: UIViewController, Buildable, WKScriptMessageHandler{
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            clg(message.body)
        }else{
            if let dic = message.body as? Dictionary<String, Any>, let type = dic["type"] as? String{
                sc.emit(type.toNotificationName(), userInfo: dic)
            }
        }
        
    }
    
    var url: URL?
    var webView:WKWebView = WKWebView(frame: .zero)
    
    public override func loadView() {
        view = webView
        
        
        if let source = Shifu.bundle.url(forResource: "web/NativeHook", withExtension: "js")?.content{
            let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(script)
            // register the bridge script that listens for the output
            webView.configuration.userContentController.add(self, name: "logHandler")
            webView.configuration.userContentController.add(self, name: "native")
            webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs");
        }
        if let url = url{
            webView.load(URLRequest(url: url))
        }
    }
    
    public func exec(script:String){
        webView.evaluateJavaScript(script){ _ , _ in 
//            clg($0, $1)
        }
//        webView.callAsyncJavaScript(script, arguments: ["id": 1], in: nil, in: .page)
    }
    
    
    
}
