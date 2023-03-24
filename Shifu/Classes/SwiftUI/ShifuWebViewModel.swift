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
public class ShifuWebViewModel:ObservableObject, Hashable{
    private let id: UUID = UUID()
//    public let env = JSEnvironment()
    public var log2EventMap:[String: String] = [:]
    public weak internal(set)var delegate: ShifuWebViewController? {
        didSet{
//            if delegate != nil {
//                env.objectWillChange.sink { [weak self] in
//                    DispatchQueue.main.async {
//                        clg(self?.env.stringify())
//                        self?.apply("""
//        if(typeof env == "undefined"){
//            globalThis.env = {}
//        }
//        Object.assign(globalThis.env, _env);
//        """, arguments: ["_env": self?.env.stringify()?.parse() ?? NSObject()])
//                    }
//                }
//                .retain(self);
//            }
        }
    }
    public var treatLoadedAsMounted = false 
    public var shared = false
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
    
    public static func == (lhs: ShifuWebViewModel, rhs: ShifuWebViewModel) -> Bool {
            return lhs.id == rhs.id
        }

     public   func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    public var sharedShifuWebViewController: ShifuWebViewController = {
        return with(ShifuWebViewController()){ (vc:ShifuWebViewController) in
            let webView = vc.webView
            webView.configuration.userContentController.add(vc, name: "logHandler")
            webView.configuration.userContentController.add(vc, name: "native")
        }
    }()
    
    public init(){ }
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
    
    @Published public internal(set)var isLoading: Bool = false
    @Published public internal(set)var isMounted: Bool = false
    public var configuration: String?
    public var baseURL: URL?
    
    var webView:WKWebView? {
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
            if !shared && isLoading && arguments["force"] as? Bool != true {
                sc.once(.MOUNTED, object: webview) { _ in
                    webview.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
                }
            } else {
                webview.callAsyncJavaScript(funtionBody, arguments: arguments, in: nil, in: .page, completionHandler: callback)
            }
        } else {
            sc.once(.MOUNTED) { notification in
                guard notification.object as? NSObject == self.delegate else { return }
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


//public final class JSEnvironment: ObservableObject, Codable {
//    @Published public var host: String = "www.abc.com"
//    enum CodingKeys: String, CodingKey {
//        case host
//    }
//    public required init() {}
//    public required init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            host = try container.decode(String.self, forKey: .host)
//        }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(host, forKey: .host)
//    }
//    
//}
