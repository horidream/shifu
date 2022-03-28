//
//  NavigationStyleDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct NavigationStyleDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        ScrollView(.vertical, showsIndicators: false) {
            NavigationDemo()
            SimpleMarkdownViewer(path: "@source/NavigationStyleDemo.md")
                .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onInjection {
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    
    
    func sandbox(){
    }
}



struct NavigationDemo: UIViewControllerRepresentable{
    class Coordinator {
        var parentObserver: NSKeyValueObservation?
        var titleObserver:NSKeyValueObservation?
    }
    func makeCoordinator() -> Self.Coordinator { Coordinator() }
    typealias UIViewControllerType = NavigationDemoViewController
    
    func makeUIViewController(context: Context) -> NavigationDemoViewController {
        let viewController =   NavigationDemoViewController()
        context.coordinator.parentObserver = viewController.observe(\.title, changeHandler: { vc, _ in
            vc.parent?.title = vc.title
            vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
        })
        context.coordinator.titleObserver = viewController.observe(\.parent, changeHandler: { vc, _ in
            vc.parent?.title = vc.title
            vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
        })
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: NavigationDemoViewController, context: Context) {
        
    }
    
}


enum NavigationStyle:String, CaseIterable{
    case feature, hub, detail, formFirstPage, formContinue, formConfirmation
    static var random:NavigationStyle
    {
        NavigationStyle.allCases.randomElement() ?? .feature
    }
}

protocol NavigationStyleConforming{
    var navigationStyle:NavigationStyle { get set }
}

extension NavigationStyleConforming where Self: UIViewController{
    func setupNavigationStyle(){
        // setup style in here
        self.title = navigationStyle.rawValue
    }
}

class NavigationDemoViewController: UIViewController, NavigationStyleConforming{
    var navigationStyle: NavigationStyle = .feature {
        didSet{
            setupNavigationStyle()
        }
    }
    
    override func viewDidLoad() {
        setupNavigationStyle()
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .map{_ in NavigationStyle.random }
            .sink{
                self.navigationStyle = $0
            }
            .retain()
    }
}
