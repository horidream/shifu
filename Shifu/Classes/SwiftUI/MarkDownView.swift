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

var vcs = [MarkDownViewController(), MarkDownViewController()]
public struct MarkDownView: UIViewControllerRepresentable{
    var id:Int
    public init(id:Int = 0 ){
        self.id = id
    }
    
    public func makeUIViewController(context: Context) -> MarkDownViewController {
        
        return vcs.get(id) ?? MarkDownViewController()
    }
    
    public func updateUIViewController(_ uiViewController: MarkDownViewController, context: Context) {
        
    }
    
    public typealias UIViewControllerType = MarkDownViewController
    
    
}




final public class MarkDownViewController: UIViewController{
    var webView:WKWebView = WKWebView(frame: .zero)
    public override func loadView() {
        view = webView
    }
    
    public override func viewDidLoad() {
        if let url = Shifu.bundle.url(forResource: "web/index", withExtension: "html"){
            webView.load(URLRequest(url: url))
        }
    }
    
}
