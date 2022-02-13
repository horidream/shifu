//
//  ShifuWebView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/12.
//

import UIKit
import SwiftUI
import WebKit
import Combine

public struct ShifuWebView: UIViewControllerRepresentable{
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    
    @Binding var script:String?
    @Binding var url:URL?
    
    @State private var request = PassthroughSubject<(String, PassthroughSubject<Any?, Never>), Never>()
    
    public func exec(script:String, callback: @escaping (Any?)->Void){
        let response = PassthroughSubject<Any?, Never>()
        request.send((script, response))
        response
            .timeout(10, scheduler: RunLoop.main)
            .first()
            .sink { data in
            callback(data)
        }.retain()
        
    }
    public init (script:Binding<String?>, url: Binding<URL?>){
        _script = script
        _url = url
    }
    
    public func makeUIViewController(context: Context) -> ShifuWebViewController {
        
        return ShifuWebViewController{ vc in
            vc.url = url
            if let script = script {
                vc.webView.evaluateJavaScript(script)
            }
            request.sink { script, response in
                vc.webView.evaluateJavaScript(script) { data, _ in
                    response.send(data)
                }
            }.store(in: &context.coordinator.bag)
        }
    }
    
    public func updateUIViewController(_ uiViewController: ShifuWebViewController, context: Context) {
        if let url = url , uiViewController.webView.url != url{
            uiViewController.webView.load(URLRequest(url: url))
        }
        uiViewController.webView.scrollView.bounces = false
        if let script = script , !script.isEmpty{
            uiViewController.exec(script: script)
        }
    }
    
    public typealias UIViewControllerType = ShifuWebViewController
    
    public class Coordinator{
        public var bag:[AnyCancellable] = []
    }
    
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
