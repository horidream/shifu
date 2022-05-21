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

public class SimpleObject{
    
}

public enum ShifuWebViewAction{
    case snapshot(WKSnapshotConfiguration? = nil, SnapshotTarget = .clipboard(.jpg))
    
    
}

@available(iOS 14.0, *)
public class ShifuWebViewModel:ObservableObject{
    public weak var delegate: ShifuWebViewController?
    public static var markdown:ShifuWebViewModel {
        .init {
            $0.allowScroll = true
            $0.url = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
        }
    }
    
    public init(){}
    public init(builder: (ShifuWebViewModel)->Void){
        builder(self)
    }
    
    @Published public var html:String?
    @Published public var allowScroll = false
    @Published public var url:URL?
    @Published public var contentHeight: CGFloat = 0
    
    public var configuration: String?
    public var baseURL: URL?
    public func exec(_ action: ShifuWebViewAction){
        switch action{
        case .snapshot(let config, let target):
            delegate?.webView.snapshot(config: config, target: target)
        default: ()
        
        }
    }
    
    public func apply(_ funtionBody:String, arguments:[String: Any] = [:], callback: ((Result<Any, Error>) -> Void)? = nil){
        self.delegate?.webView.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
    }
}

@available(iOS 14.0, *)
public struct ShifuWebView: UIViewControllerRepresentable{
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    @ObservedObject var viewModel:ShifuWebViewModel
    
    public func autoResize()-> some View{
        self
            .frame(minHeight: viewModel.contentHeight)
            .on("contentHeight", target: viewModel.delegate){
                if let height = $0.userInfo?["value"] as? CGFloat, height != viewModel.contentHeight {
                    self.viewModel.contentHeight = height
                }
            }
    }
    
    public init (viewModel:ShifuWebViewModel = ShifuWebViewModel()){
        self.viewModel = viewModel
    }
    
    public func makeUIViewController(context: Context) -> ShifuWebViewController {
        let vc = ShifuWebViewController()
        if let html = viewModel.html, html != viewModel.html{
            vc.webView.loadHTMLString(html, baseURL: viewModel.baseURL)
        }
        if let conf = viewModel.configuration{
            let script = WKUserScript(source: conf, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            vc.webView.configuration.userContentController.addUserScript(script)
        }
        viewModel.delegate = vc
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: ShifuWebViewController, context: Context) {
        let webView = uiViewController.webView
        webView.scrollView.bounces = viewModel.allowScroll
        webView.scrollView.isScrollEnabled = viewModel.allowScroll
        if let url = viewModel.url , webView.url != url{
            webView.load(URLRequest(url: url))
        }
        
        if let html = viewModel.html, html != uiViewController.lastLoadedHTML {
            uiViewController.lastLoadedHTML = html
            webView.loadHTMLString(html, baseURL: viewModel.baseURL)
        }
        
        
    }
    
    public typealias UIViewControllerType = ShifuWebViewController
    
    public class Coordinator{
        public var bag:[AnyCancellable] = []
    }
    
}



final public class ShifuWebViewController: UIViewController, WKScriptMessageHandler{
    var lastLoadedHTML:String?
    init(id: SimpleObject = SimpleObject()){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            clg("logHandler", message.body)
        }else{
            if let dic = message.body as? Dictionary<String, Any>, let type = dic["type"] as? String{
//                clg(type, dic)
                NotificationCenter.default.post(name: type.toNotificationName(), object: self, userInfo: dic)
            }
        }
        
    }
    
    var url: URL?
    var webView:WKWebView = WKWebView(frame: .zero)
    
    public override func loadView() {
        view = webView
        webView.isOpaque = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        if let source = Shifu.bundle.url(forResource: "web/NativeHook", withExtension: "js")?.content, let postSource = Shifu.bundle.url(forResource: "web/PostNativeHook", withExtension: "js")?.content{
            let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            let postScript = WKUserScript(source: postSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(script)
            webView.configuration.userContentController.addUserScript(postScript)
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


