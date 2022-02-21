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


public enum ShifuWebViewAction{
    case none, snapshot(WKSnapshotConfiguration? = nil, SnapshotTarget = .clipboard(.jpg))
}

public class ShifuWebViewModel:ObservableObject{
    public init(){}
    public init(builder: (ShifuWebViewModel)->Void){
        builder(self)
    }
    
    @Published public var html:String?
    @Published public var action:ShifuWebViewAction = .none
    public var baseURL: URL?
    
}

public struct ShifuWebView: UIViewControllerRepresentable{
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    let viewModel:ShifuWebViewModel
    @Binding var script:String?
    @Binding var url:URL?
    @Binding var allowScroll:Bool
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
    
    
    public init (viewModel:ShifuWebViewModel = ShifuWebViewModel(), script:Binding<String?> = .constant(nil), url: Binding<URL?> = .constant(nil), allowScroll: Binding<Bool> = .constant(false)){
        self.viewModel = viewModel
        _script = script
        _url = url
        _allowScroll = allowScroll
    }
    
    public func makeUIViewController(context: Context) -> ShifuWebViewController {
        ShifuWebViewController{ vc in
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
        if(!allowScroll){
            uiViewController.webView.scrollView.bounces = false
            uiViewController.webView.scrollView.isScrollEnabled = false
        }
        if let url = url , uiViewController.webView.url != url{
            uiViewController.webView.load(URLRequest(url: url))
        }
        if let script = script , !script.isEmpty{
            uiViewController.exec(script: script)
        }
        if let html = viewModel.html{
            uiViewController.webView.loadHTMLString(html, baseURL: viewModel.baseURL)
        }
        
        switch viewModel.action{
        case .none:()
        case .snapshot(let config, let target):
            uiViewController.webView.snapshot(config: config, target: target)
            viewModel.action = .none
            
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
                NotificationCenter.default.post(name: type.toNotificationName(), object: self, userInfo: dic)
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

public protocol Buildable{
    init(builder: (Self)->Void)
}

public extension Buildable where Self:NSObject {
    init(builder: (Self)->Void){
        self.init()
        builder(self)
    }
}



public class EmptyObject{
    public static let shared = EmptyObject()
}


