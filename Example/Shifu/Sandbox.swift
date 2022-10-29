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
    @Persist("hello") var hello = "OK"
    @State var arr = ["1","2","3"]
    @State var selected:String?
    var body: some View {
        ViewWrapper16(forceLegacy:false){
            if #available(iOS 16, *) {
                NavigationSplitView{
                    List($arr, id: \.self, selection: $selected) { $i in
                        Text(i)
                    }
                } detail: {
                    Text("You selecrted \(selected ?? "nothing" )")
                }
            }
        } legacyView: {
            Text("OK")
            
        }
        .onAppear{
            sandbox()
        }
        .onInjection{
            sandbox()
        }
        

    }
    
    
    
    func sandbox(){
        clg("<a>hello</a>".textExtractedFromHTML)
        let html = "<a>hello\n</a> "
        clg(html.trimmingCharacters(in: .whitespaces).test(pattern: "^<.*>$"))
        //        let doc = try? SwiftSoup.parse(html)
        clg(Bundle.main.url(forResource: "Chunli2/icon", withExtension: "png"))
        clg("@lottie_example.json".url)
    }
    
}



struct SplitView<Master: View, Detail: View>: View {
    var master: Master
    var detail: Detail
    
    init(@ViewBuilder master: () -> Master, @ViewBuilder detail: () -> Detail) {
        self.master = master()
        self.detail = detail()
    }
    
    var body: some View {
        let viewControllers = [UIHostingController(rootView: master), UIHostingController(rootView: detail)]
        return SplitViewController(viewControllers: viewControllers)
    }
}

struct SplitViewController: UIViewControllerRepresentable {
    var viewControllers: [UIViewController]
    @Environment(\.splitViewPreferredDisplayMode) var preferredDisplayMode: UISplitViewController.DisplayMode
    
    func makeUIViewController(context: Context) -> UISplitViewController {
        return UISplitViewController()
    }
    
    func updateUIViewController(_ splitController: UISplitViewController, context: Context) {
        splitController.preferredDisplayMode = preferredDisplayMode
        splitController.viewControllers = viewControllers
    }
}

struct PreferredDisplayModeKey : EnvironmentKey {
    static var defaultValue: UISplitViewController.DisplayMode = .automatic
}

extension EnvironmentValues {
    var splitViewPreferredDisplayMode: UISplitViewController.DisplayMode {
        get { self[PreferredDisplayModeKey.self] }
        set { self[PreferredDisplayModeKey.self] = newValue }
    }
}

extension View {
    /// Sets the preferred display mode for SplitView within the environment of self.
    func splitViewPreferredDisplayMode(_ mode: UISplitViewController.DisplayMode) -> some View {
        self.environment(\.splitViewPreferredDisplayMode, mode)
    }
}


struct ViewWrapper16<ModernView: View, LegacyView: View>:View {
    var forceLegacy:Bool = false
    var modernView: ModernView
    var legacyView: LegacyView
    
    init(forceLegacy: Bool = false, @ViewBuilder moderView: ()-> ModernView, @ViewBuilder  legacyView:  ()->LegacyView){
        self.forceLegacy = forceLegacy
        self.modernView = moderView()
        self.legacyView = legacyView()
    }
    public var body: some View{
        if #available(iOS 16, *) {
            if forceLegacy {
                    legacyView
            } else {
                
                modernView
            }
        } else {

                legacyView
        }
    }
}
