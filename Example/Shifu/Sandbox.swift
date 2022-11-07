//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import ShifuWebServer
import UniformTypeIdentifiers
import CoreServices
import Combine
import PencilKit
import SwiftSoup

struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var isLegacySplitView = false
    @Persist("shouldShowNaivigationBar") var shouldShowNaivigationBar:Bool = true
    @State var arr = ["1","2","3"]
    var body: some View {
        ShifuSplitView(data: $arr) { i in
            Text(i)
        } detail: { selected in
            
            switch selected {
            case "1":
                ZStack{
                    Toggle("Force Legacy", isOn: $isLegacySplitView)
                    ShifuPasteButton(view: {
                        Image(.paste, size: 34)
                    }, onPaste: { items in
                        clg(items)
                    }, config: { config in
                        config.forceLegacy = isLegacySplitView
                    })
                }
                .padding()
            default:
                Text("You selecrted \(selected ?? "nothing" )")
            }
        } config: { config in
            config.navigationTitle = Text("Hello")
            config.navigationBarTitleDisplayMode = .automatic
            config.navigationBarHidden = (!shouldShowNaivigationBar, !shouldShowNaivigationBar)
        }
        .navigationBarHidden(shouldShowNaivigationBar)
        .navigationTitle("ShifuSplitView Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                Toggle("Show Navigation Bar", isOn: $shouldShowNaivigationBar)
            }
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        
        
    }
    
    func sandbox(){
        if let navi = _rootViewController.children.first as? UINavigationController, let vc = navi.topViewController
        {
            let img = UIImage(named: "cover")?.withRenderingMode(.alwaysOriginal)
            let v = UIImageView(image: img)
            vc.view.addSubview(v)
            v.tag = 99
            vc.view.viewWithTag(99)?.removeFromSuperview()
            vc.view.addSubview(v)
            v.layer.masksToBounds = true
            v.layer.cornerRadius = 49
            v.quickMargin(10)
        }
        
    }
    
}

extension Test{
    @objc func test(){
    }
}

protocol LayoutTarget{
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}
