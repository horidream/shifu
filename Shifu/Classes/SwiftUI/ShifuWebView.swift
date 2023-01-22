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
    public weak fileprivate(set)var delegate: ShifuWebViewController?
    public var metaData = """
<meta
    name="viewport"
    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    />
"""
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
    
    @Published public var html:String?{
        didSet{
            if oldValue != html, html != nil{
                isLoading = true
            }
        }
    }
    @Published public var allowScroll = false
    @Published public var url:URL?{
        didSet{
            if oldValue != url, url != nil{
                isLoading = true
            }
        }
    }
    @Published public var contentHeight: CGFloat = 0
    
    @Published public fileprivate(set)var isLoading: Bool = false
    @Published public fileprivate(set)var isMounted: Bool = false
    public var configuration: String?
    public var baseURL: URL?
    
    public func publisher(of name: String)->NotificationCenter.Publisher{
        NotificationCenter.default.publisher(for: name.toNotificationName(), object: delegate)
    }
    
    public func exec(_ action: ShifuWebViewAction, callback: ((Any?)->Void)? = nil){
        switch action{
        case .snapshot(let config, let target):
            if let webView = self.delegate?.webView {
               webView.snapshot(config: config, target: target, callback: callback)
            } else {
                sc.on(.MOUNTED) { notify in
                    clg("mounted", notify.object)
                    self.delegate?.webView.snapshot(config: config, target: target, callback: callback)
                }
            }
        default: ()
        
        }
    }
    
    public func apply(_ funtionBody:String, arguments:[String: Any] = [:], callback: ((Result<Any, Error>) -> Void)? = nil){
        if let webview = self.delegate?.webView {
            if isLoading {
                sc.once(.LOADED, object: webview) { _ in
                    webview.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
                }
            } else {
                webview.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
            }
        } else {
            sc.once(.MOUNTED) { _ in
                self.delegate?.webView.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
            }
        }
    }
    
    public func apply(_ funtionBody:String, arguments:[String: Any] = [:], callback: ((Any) -> Void)? = nil){
        let onComplete:((Result<Any, Error>) -> Void) = {
            if case .success(let payload) = $0 {
                callback?(payload) // <h2>Horidream</h2><p>hihihihi</p>
            } else {
                clg($0)
            }
        }
        apply(funtionBody, arguments: arguments, callback: onComplete)
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
    
    public init (url: URL?){
        self.viewModel = ShifuWebViewModel{
            $0.url = url
        }
    }
    
    public init (html: String?){
        self.viewModel = ShifuWebViewModel{
            $0.html = html
        }
    }
    
    public func makeUIViewController(context: Context) -> ShifuWebViewController {
        let vc = ShifuWebViewController()
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
        webView.scrollView.contentInsetAdjustmentBehavior = .never // when ignoring the safe area, we can have a fullscreen webview
        if let url = viewModel.url , webView.url != url{
            viewModel.isLoading = true
            webView.load(URLRequest(url: url))
            sc.once(.LOADED, object: webView) { _ in
                viewModel.isLoading = false
            }
        }
        
        if let html = viewModel.html, html != uiViewController.lastLoadedHTML {
            uiViewController.lastLoadedHTML = html
            viewModel.isLoading = true
            webView.loadHTMLString( viewModel.metaData + html, baseURL: viewModel.baseURL)
            sc.once(.LOADED, object: webView) { _ in
                viewModel.isLoading = false
            }
        }
        
        
    }
    
    public typealias UIViewControllerType = ShifuWebViewController
    
    public class Coordinator{
        public var bag:[AnyCancellable] = []
    }
    
}



final public class ShifuWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate{
    var lastLoadedHTML:String?
    init(id: SimpleObject = SimpleObject()){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "logHandler":
            clg("[log]", message.body)
        default:
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
        webView.navigationDelegate = self
        if let source = Shifu.bundle.url(forResource: "web/NativeHook", withExtension: "js")?.content, let postSource = Shifu.bundle.url(forResource: "web/PostNativeHook", withExtension: "js")?.content{
            let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            let postScript = WKUserScript(source: postSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(script)
            webView.configuration.userContentController.addUserScript(postScript)
            
            webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs");
        }
        if let url = url{
            webView.load(URLRequest(url: url))
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // register the bridge script that listens for the output
        webView.configuration.userContentController.add(self, name: "logHandler")
        webView.configuration.userContentController.add(self, name: "native")
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
    
   
    // MARK: DELEGATE
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        clg("ShifuWebViewController: \(error)")
    }
    
//    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        clg("start loading")
//    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        sc.emit(.LOADED, object: webView)
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


