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
import JavaScriptCore

public enum ShifuWebViewAction{
    case snapshot(WKSnapshotConfiguration? = nil, SnapshotTarget = .clipboard(.jpg))
}






@available(iOS 14.0, *)
public struct ShifuWebView: UIViewControllerRepresentable{
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    @ObservedObject var viewModel1:ShifuWebViewModel = .noop
    var viewModel2:ShifuWebViewModel = ShifuWebViewModel()
    var viewModel:ShifuWebViewModel {
        return viewModel1.isNoop ?  viewModel2 : viewModel1
    }

    public func autoResize()-> some View{
        self
            .frame(minHeight: viewModel.contentHeight)
            .on("contentHeight", target: viewModel.webView){
                if let height = $0.userInfo?["value"] as? CGFloat, height != viewModel.contentHeight {
                    self.viewModel.contentHeight = height
                }
            }
    }
    
    public init (viewModel:ShifuWebViewModel ){
        self.viewModel1 = viewModel
    }
    
    public init (url: URL?){
        self.viewModel2.url = url
    }
    
    public init (html: String?){
        self.viewModel2.html = html
    }
    
    func reinitializeSharedShifuWebViewController(){
        with(viewModel.sharedShifuWebViewController){ vc in
            if let source = Shifu.bundle.url(forResource: "web/NativeHook", withExtension: "js")?.content, let postSource = Shifu.bundle.url(forResource: "web/PostNativeHook", withExtension: "js")?.content{
                vc.webView.configuration.userContentController.removeAllUserScripts()
                let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
                let postScript = WKUserScript(source: postSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                vc.webView.configuration.userContentController.addUserScript(script)
                vc.webView.configuration.userContentController.addUserScript(postScript)
                vc.webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs");
                let websiteDataStore = WKWebsiteDataStore.default()
                let date = Date(timeIntervalSince1970: 0)
                websiteDataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: date) { [weak vc] in
                    vc?.webView.configuration.websiteDataStore = websiteDataStore
                }
            }
        }
    }
    
    public func makeUIViewController(context: Context) -> ShifuWebViewController {

        let vc = viewModel.shared ? viewModel.sharedShifuWebViewController : ShifuWebViewController()
        if let conf = viewModel.configuration{
            let script = WKUserScript(source: conf, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            reinitializeSharedShifuWebViewController()
            vc.webView.configuration.userContentController.addUserScript(script)
        }
        viewModel.delegate = vc
        vc.model = viewModel
        if(viewModel.shared){
            viewModel.isLoading = false
            viewModel.isMounted = true
        }
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: ShifuWebViewController, context: Context) {
        let webView = uiViewController.webView
        webView.scrollView.bounces = viewModel.allowScroll
        webView.scrollView.isScrollEnabled = viewModel.allowScroll
        webView.scrollView.contentInsetAdjustmentBehavior = .never // when ignoring the safe area, we can have a fullscreen webview
        if let extraMenus = viewModel.extraMenus{
            for (menu, block) in extraMenus{
                webView.addCustomMenuItem(menu, block)
            }
        }

        if let url = viewModel.url ,context.coordinator.previousURL?.absoluteString.trimmingCharacters(in: .punctuationCharacters) != url.absoluteString.trimmingCharacters(in: .punctuationCharacters){
                viewModel.isLoading = true
                observeMounted(webView: webView, model: viewModel)
                webView.load(URLRequest(url: url))
                context.coordinator.previousURL = url
        }
        
        if let html = viewModel.html, html != uiViewController.lastLoadedHTML {
            uiViewController.lastLoadedHTML = html
            webView.loadHTMLString( viewModel.metaData + html, baseURL: viewModel.baseURL)
            viewModel.isMounted = true
        }
        
        
    }
    
    func observeMounted(webView: WKWebView, model:  ShifuWebViewModel){
        sc.once(.LOADED, object: webView) { _ in
            viewModel.isLoading = false
            if(viewModel.treatLoadedAsMounted){
                sc.emit(.MOUNTED, object: webView)
            }
        }
        sc.once(.MOUNTED, object: webView){ _ in
            viewModel.isMounted = true;
        }
    }
    
    public typealias UIViewControllerType = ShifuWebViewController
    
    public class Coordinator{
        var previousURL: URL?
        public var bag:[AnyCancellable] = []
    }
    
}



final public class ShifuWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate{
    var lastLoadedHTML:String?
    weak var model: ShifuWebViewModel? {
        didSet{
            if let model = model, model != oldValue {
                webView.configuration.userContentController.removeScriptMessageHandler(forName: "webViewBridge")
                webView.configuration.userContentController.add(model, name: "webViewBridge");
            }
        }
    }
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "logHandler":
            if let rules = model?.log2EventMap, let log = message.body as? String{
                for rule in rules {
                    if (try? NSRegularExpression(pattern: rule.key).test(log)) == true{
                        sc.emit(rule.value.toNotificationName(), object: self.view)
                    }
                }
            }
            if(Shifu.config.shouldPrintWebLog){
                clg("[log]", message.body)
            }
        default:
            if let dic = message.body as? Dictionary<String, Any>, let type = dic["type"] as? String{
//                                clg(type, dic)
                NotificationCenter.default.post(name: type.toNotificationName(), object: webView, userInfo: dic)
            }
        }
    }
    
    var url: URL?
    public var webView:CustomWebView = CustomWebView(frame: .zero, configuration: with(WKWebViewConfiguration()){
        // this must be set in the constructor
        $0.allowsInlineMediaPlayback = true
    })
    
    public override func loadView() {
        view = webView
        
        webView.isOpaque = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self
        if let source = Shifu.bundle.url(forResource: "web/NativeHook", withExtension: "js")?.content, let postSource = Shifu.bundle.url(forResource: "web/PostNativeHook", withExtension: "js")?.content{
            let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            let postScript = WKUserScript(source: postSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(script)
            webView.configuration.userContentController.addUserScript(postScript)
            webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs");
            let websiteDataStore = WKWebsiteDataStore.default()
            let date = Date(timeIntervalSince1970: 0)
            websiteDataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: date) { [weak self] in
                self?.webView.configuration.websiteDataStore = websiteDataStore
            }
        }
        if let url = url{
            webView.load(URLRequest(url: url))
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // register the bridge script that listens for the output
        if(model?.shared != true){
            webView.configuration.userContentController.add(self, name: "logHandler")
            webView.configuration.userContentController.add(self, name: "native")
        }
        if let allowedMenus = model?.allowedMenus{
            webView.allowedMenus = allowedMenus
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(model?.shared != true){
            webView.configuration.userContentController.removeAllScriptMessageHandlers()
        }
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

public class CustomWebView: WKWebView {
    var allowedMenus:[String] = []
    var blockMap = Dictionary<String, (String)->Void>()
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(customAction) {
            return true
        }
        for str in allowedMenus {
            if action.description.test(pattern: str){
                return true
            }
        }
        return false
    }

    override public var canBecomeFirstResponder: Bool {
        return true
    }

    @objc func customAction(_ command: UICommand) {
        self.evaluateJavaScript("window.getSelection().toString()") { (result, error) in
            if let selectedText = result as? String {
                self.blockMap[command.title]?(selectedText)
            }
        }
    }
    
    // Call this method when page finishes loading
    public func  addCustomMenuItem(_ title: String, _ block:@escaping (String)->Void) {
        let customMenuItem = UIMenuItem(title: title, action: #selector(customAction))
        blockMap[title] = block
        if var arr = UIMenuController.shared.menuItems{
            arr.append(customMenuItem)
        } else {
            UIMenuController.shared.menuItems = [customMenuItem]
        }
    }
}

