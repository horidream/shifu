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
public class ShifuWebViewModel: NSObject, ObservableObject{
    
    public var log2EventMap:[String: String] = [:]
    public weak internal(set)var delegate: ShifuWebViewController? {
        didSet{
            
        }
    }
    public var treatLoadedAsMounted = false 
    public var shared = false
    public var extraMenus:Dictionary<String, (String)->Void>?
    public var allowedMenus:[String] = []
    public var metaData = """
<meta
    name="viewport"
    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    />
"""
    public static var noop:ShifuWebViewModel = .init()
    var isNoop:Bool {
        return self == Self.noop
    }
    public static var markdown:ShifuWebViewModel {
        .init {
            $0.allowScroll = true
            $0.url = Shifu.bundle.url(forResource: "web/index", withExtension: "html")
        }
    }
    
    public var sharedShifuWebViewController: ShifuWebViewController = {
        return with(ShifuWebViewController()){ (vc:ShifuWebViewController) in
            let webView = vc.webView
            webView.configuration.userContentController.add(vc, name: "logHandler")
            webView.configuration.userContentController.add(vc, name: "native")
        }
    }()
    
    public override init(){ }
    public init(builder: (ShifuWebViewModel)->Void){
        super.init()
        builder(self)
    }
    @Published public var bridge: [String: Any] = [:]
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
            } else {
                isLoading = false
            }
        }
    }
    @Published public var contentHeight: CGFloat = 0
    
    @Published public internal(set)var isLoading: Bool = false
    @Published public internal(set)var isMounted: Bool = false
    @Published public var configuration: String?
    public var baseURL: URL?
    
    public var webView:WKWebView? {
        return self.delegate?.webView
    }
    
    public func publisher(of name: String)->NotificationCenter.Publisher{
        NotificationCenter.default.publisher(for: name.toNotificationName(), object: delegate)
    }
    
    public func emptyCookies(){
        let cookieStorage = HTTPCookieStorage.shared
        for cookie in cookieStorage.cookies ?? [] {
            cookieStorage.deleteCookie(cookie)
        }
        webView?.reload()
    }
    
    public func setCookies(_ jsonArray: AnyObject?, force: Bool = false) {
        if !force, let cookieStore = webView?.configuration.websiteDataStore.httpCookieStore{
            cookieStore.getAllCookies { cookies in
                if !cookies.isEmpty {
                    clg("not empty, abort")
                    return
                }
            }
        }
        guard let cookieStore = webView?.configuration.websiteDataStore.httpCookieStore else {
            print("No cookie store available")
            return
        }
        guard let arr = jsonArray as? NSArray else {
            print("input is not valid")
            return 
        }
        
        for case let cookieDict as NSDictionary in arr {
            guard let name = cookieDict["name"] as? String,
                  let value = cookieDict["value"] as? String,
                  let domain = cookieDict["domain"] as? String,
                  let path = cookieDict["path"] as? String else {
                print("Missing required cookie attributes")
                continue
            }

            // Handle expirationDate if it exists
            var cookieProperties: [HTTPCookiePropertyKey: Any] = [
                .domain: domain,
                .path: path,
                .name: name,
                .value: value,
                .sameSitePolicy: "none",
                .secure: true
            ]
            
            // If the cookie is not a session cookie, set the expiration date
            if let expirationTimestamp = cookieDict["expirationDate"] as? TimeInterval, cookieDict["session"] as? Bool == false {
                cookieProperties[.expires] = Date(timeIntervalSince1970: expirationTimestamp)
            }

            // Create the cookie
            if let cookie = HTTPCookie(properties: cookieProperties) {
                cookieStore.setCookie(cookie) {
//                    print("Cookie \(name) set successfully")
                }
            } else {
                print("Failed to create cookie for \(name)")
            }
        }
        webView?.reload()
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
        if let webview = self.webView {
            if !shared && isLoading && arguments["force"] as? Bool != true {
                sc.once(.READY, object: webview) { _ in
                    webview.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
                }
            } else {
                webview.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
            }
        }
        else {
            sc.once(.READY) { notification in
                guard notification.object as? WKWebView == self.webView else { return }
                self.webView?.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
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
    
    /// Configure the underlying WKWebView directly using a configuration closure
    /// - Parameter configure: A closure that takes the WKWebView as a parameter
    /// - Returns: Self for chaining
    @discardableResult
    public func configureWebView(_ configure: @escaping (WKWebView) -> Void) -> Self {
        if let webView = self.webView {
            configure(webView)
        } else {
            // If webView is not available yet, wait until it's mounted
            sc.once(.MOUNTED) { notification in
                guard let webView = self.webView else { return }
                configure(webView)
            }
        }
        return self
    }
}


extension ShifuWebViewModel:WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "webViewBridge", let receivedObject = message.body as? [String: Any] {
            bridge = receivedObject
        }
    }
}
