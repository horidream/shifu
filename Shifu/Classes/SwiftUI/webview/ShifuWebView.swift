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

@available(iOS 14.0, *)
public struct ShifuWebView: UIViewControllerRepresentable{
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    @ObservedObject var injectedViewModel:ShifuWebViewModel = .noop
    var internalViewModel:ShifuWebViewModel = ShifuWebViewModel()
    var viewModel:ShifuWebViewModel {
        return injectedViewModel.isNoop ?  internalViewModel : injectedViewModel
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
        self.injectedViewModel = viewModel
    }
    
    public init (url: URL?){
        self.internalViewModel.url = url
    }
    
    public init (html: String?){
        self.internalViewModel.html = html
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
        }
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: ShifuWebViewController, context: Context) {
        let webView = uiViewController.webView
        webView.scrollView.bounces = viewModel.allowScroll
        webView.scrollView.isScrollEnabled = viewModel.allowScroll
        webView.scrollView.contentInsetAdjustmentBehavior = .never // when ignoring the safe area, we can have a fullscreen webview
        
        if (viewModel.url == nil && (viewModel.html?.isEmpty ?? true)){
            webView.stopLoading()
            webView.loadHTMLString("", baseURL: nil)
        } else {
            if let extraMenus = viewModel.extraMenus{
                for (menu, block) in extraMenus{
                    webView.addCustomMenuItem(menu, block)
                }
            }
            
            if let url = viewModel.url ,context.coordinator.previousURL?.absoluteString.trimmingCharacters(in: .punctuationCharacters) != url.absoluteString.trimmingCharacters(in: .punctuationCharacters){
                delay(0){
                    observeMounted(webView: webView, model: viewModel)
                    webView.load(URLRequest(url: url))
                    context.coordinator.previousURL = url
                    viewModel.isLoading = true
                }
            }
            
            if let html = viewModel.html, html != uiViewController.lastLoadedHTML {
                delay(0){
                    uiViewController.lastLoadedHTML = html
                    webView.loadHTMLString( viewModel.metaData + html, baseURL: viewModel.baseURL)
                }
            }
        }
        
    }
    
    func observeMounted(webView: WKWebView, model:  ShifuWebViewModel){
        sc.once(.LOADED, object: webView) { _ in
            viewModel.isLoading = false
            if(viewModel.treatLoadedAsMounted){
                sc.emit(.MOUNTED, object: webView)
            }
        }
        // MOUNTED event handling removed - using "ready" signal instead
    }
    
    public typealias UIViewControllerType = ShifuWebViewController
    
    public class Coordinator{
        var previousURL: URL?
        public var bag:[AnyCancellable] = []
    }
    
}



final public class ShifuWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate{
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
                NotificationCenter.default.post(name: type.toNotificationName(), object: webView, userInfo: dic)
            }
        }
    }
    
    var url: URL?
    public var webView:CustomWebView = CustomWebView(frame: .zero, configuration: with(WKWebViewConfiguration()){
        // this must be set in the constructor
        $0.allowsInlineMediaPlayback = true
//        $0.mediaTypesRequiringUserActionForPlayback = []
//        $0.websiteDataStore = WKWebsiteDataStore.default()
    })
    
    public override func loadView() {
        view = webView
        
        webView.isOpaque = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        if let source = Shifu.bundle.url(forResource: "web/NativeHook", withExtension: "js")?.content, let postSource = Shifu.bundle.url(forResource: "web/PostNativeHook", withExtension: "js")?.content{
            let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            let postScript = WKUserScript(source: postSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(script)
            webView.configuration.userContentController.addUserScript(postScript)
            webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs");
            webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36"
            // remove all cookies
//            let websiteDataStore = WKWebsiteDataStore.default()
//            let date = Date(timeIntervalSince1970: 0)
//            websiteDataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: date) { [weak self] in
//                self?.webView.configuration.websiteDataStore = websiteDataStore
//            }
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
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Coordinate with ShifuWebViewModel lifecycle
        if let model = model {
            DispatchQueue.main.async {
                model.isLoading = true
                model.isReady = false
            }
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        clg("ShifuWebViewController: \(error)")

        // Coordinate with ShifuWebViewModel lifecycle
        if let model = model {
            DispatchQueue.main.async {
                model.isLoading = false
            }
        }
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        clg("ShifuWebViewController: Provisional navigation failed: \(error)")

        // Coordinate with ShifuWebViewModel lifecycle
        if let model = model {
            DispatchQueue.main.async {
                model.isLoading = false
            }
        }
    }
    
    public func webView(
            _ webView: WKWebView,
            requestMediaCapturePermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            type: WKMediaCaptureType,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
        ) {
            decisionHandler(.grant)
        }
//    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        clg("start loading")
//    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        sc.emit(.LOADED, object: webView)

        // Coordinate with ShifuWebViewModel lifecycle
        if let model = model {
            DispatchQueue.main.async {
                model.isLoading = false
            }
            // Listen for "ready" message from JavaScript instead of using hardcoded delay
            sc.once(.READY, object: webView) { _ in
                DispatchQueue.main.async {
                    model.isReady = true
                    model.executeQueuedJavaScript()
                }
            }
        }
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

