//
//  HomeViewModel.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI
import Shifu

class FeatureViewModel<Content>: ObservableObject{
    let name:String
    @Published var isActive = false
    let viewBuilder:(FeatureViewModel)-> Content
    
    init(name:String, @ViewBuilder viewBuilder:@escaping (FeatureViewModel)->Content){
        self.name = name
        self.viewBuilder = viewBuilder
    }
    var view:Content{
        viewBuilder(self)
    }
}


class HomeViewModel: ObservableObject, AppModel, AppModelWeb, AppModelReachability{
    var ext: [String : Any] = [:]
    typealias Root = HomeView
    
    @Published var featureList:[FeatureViewModel<AnyView>] = []
    @Published var script:String = ""
    init(){
      Shifu.locale = .zh_CN
        refresh()
    }
    
    func refresh(){
        featureList = [
            FeatureViewModel(name: "MarkdownView", viewBuilder: { model in
                return WebViewDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "ColorThemeManager", viewBuilder: { model in
                return ColorThemeManagerDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "ShifuWebView", viewBuilder: { model in
                return ShifuWebViewDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "SoundWaveImage", viewBuilder: { model in
                return SoundWaveImageDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "ToMarkdown", viewBuilder: { model in
                return ToMarkdownDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Models", viewBuilder: { model in
                return ModelDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Animation Demo", viewBuilder: { model in
                return AnimationDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "NavigationStyle", viewBuilder: { model in
                return NavigationStyleDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Sandbox", viewBuilder: { model in
                return Sandbox().eraseToAnyView()
                
            })
        ]
        featureList.get(-1)?.isActive = true
    }
    
}
