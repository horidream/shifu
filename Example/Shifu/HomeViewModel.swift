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

class FeatureViewModel<Content>: ObservableObject, Hashable, Identifiable{
    static func == (lhs: FeatureViewModel<Content>, rhs: FeatureViewModel<Content>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    let name:String
    var icon: Icons.Name? = .swift_fa
    var color: Color? = .orange
    let id = UUID()
    @Published var isActive = false
    let viewBuilder:(FeatureViewModel)-> Content
    
    init(name:String, @ViewBuilder viewBuilder:@escaping (FeatureViewModel)->Content){
        self.name = name
        self.viewBuilder = viewBuilder
    }
    var view:Content{
        viewBuilder(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
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
            FeatureViewModel(name: "MarkdownView") { model in
                model.icon = .markdown
                model.color = .blue
                return WebViewDemo().eraseToAnyView()
            },
            FeatureViewModel(name: "ColorThemeManager", viewBuilder: { model in
                model.color = .purple
                model.icon = .masksTheater
                return ColorThemeManagerDemo().eraseToAnyView()
            }),
            FeatureViewModel(name: "ShifuWebView", viewBuilder: { model in
                model.icon = .jedi
                model.color = .red
                return ShifuWebViewDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "SoundWaveImage", viewBuilder: { model in
                model.icon = .fileWaveform
                model.color = .teal
                return SoundWaveImageDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "ToMarkdown", viewBuilder: { model in
                model.icon = .markdown
                model.color = .init(0xFFD700)
                return ToMarkdownDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Models", viewBuilder: { model in
                model.icon = .modx
                return ModelDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Animation Demo", viewBuilder: { model in
                model.icon = .earthOceania
                model.color = .blue
                return AnimationDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "NavigationStyle", viewBuilder: { model in
                return NavigationStyleDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Validate2FAPrototype", viewBuilder: { model in
                model.icon = .paypal
                model.color = .blue
                return Validate2FAPrototype().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "ShimmerDemo") { model in
                model.icon = .star_fa
                model.color = .purple
                return ShimmerDemo().eraseToAnyView()
            },
            FeatureViewModel(name: "PowerTableDemo"){ model in
                model.icon = .table
                model.color = .yellow
                return PowerTableDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "IconsDemo", viewBuilder: { model in
                model.icon = .artstation
                model.color = .indigo
                return IconsDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "NotificationManagerDemo", viewBuilder: { model in
                model.icon = .note
                model.color = .green
                return NotificationManagerDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "OnEnterFrameDemo") { model in
                model.icon = .photoFilm
                model.color = .blue
                return OnEnterFrameDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "StickyIconDemo") { model in
                model.icon = .icons
                model.color = .red
                return StickyIconDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "AttributedStringDemo") { model in
                model.icon = .fonticonsFi
                model.color = Color(0x994844)
                return AttributedStringDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "NavigationAnimationDemo") { model in
                model.icon = .link_fa
                model.color = Color(.red)
                return NavigationAnimationDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "Sandbox") { model in
                model.icon = .gitlab
                model.color = .blue
                return Sandbox().eraseToAnyView()
                
            }
        ].reversed()
        featureList.get(0)?.isActive = true
    }
    
}



