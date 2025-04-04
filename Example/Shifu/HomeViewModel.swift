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
import ShifuWebServer

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
        let _ = self.view
    }
    var view:Content{
        viewBuilder(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}


class HomeViewModel: ObservableObject, AppModel, AppModelWeb, AppModelReachability{
    typealias Root = HomeView
    @Published var youglish:ShifuWebViewModel = {with(ShifuWebViewModel()){ vc in
        vc.log2EventMap = ["onPlayerReady": "onPlayerReady"]
        vc.treatLoadedAsMounted = true
        vc.shared = true
    }
    }()
    @Published var featureList:[FeatureViewModel<AnyView>] = []
    var startIndex = 0
    init(){
        Shifu.locale = .zh_CN
        refresh()
    }
    
 
    func refresh(){
        featureList = [
            FeatureViewModel(name: "WebView") { model in
                model.icon = .markdown
                model.color = .blue
                return WebViewDemo().eraseToAnyView()
            },
            FeatureViewModel(name: "Youglish") { model in
                model.icon = .youtube
                model.color = .red
                return YouglishWebViewDemo().eraseToAnyView()
                
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
            FeatureViewModel(name: "SceneAndPerson") { model in
                model.icon = .snapchatSquare
                model.color = .green
                return SceneAndPerson().eraseToAnyView()
                
            },
            FeatureViewModel(name: "ChangeAppIconDemo") { model in
                model.icon = .appGiftFill
                model.color = .purple
                return ChangeAppIconDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "PreviewDemo") { model in
                model.icon = .docViewfinder
                model.color = .blue
                return PreviewDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "DrawingViewDemo") { model in
                model.icon = .handDraw
                model.color = .indigo
                return DrawingViewDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "ShifuSplitViewDemo") { model in
                model.icon = .squareSplit2x1
                model.color = .blue
                return ShifuSplitViewDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "PeerToPeerDemo") { model in
                model.icon = .link_sf
                model.color = .gray
                return PeerToPeerDemo().eraseToAnyView()
                
            },
            FeatureViewModel(name: "PopoverDemo") { model in
                model.icon = .popcornFill
                model.color = .yellow
                return PopoverDemo().eraseToAnyView()
                
            },

            FeatureViewModel(name: "Custom Server") { model in
                model.icon = .server
                model.color = .purple
                return CustomServer().eraseToAnyView()
                
            },
            FeatureViewModel(name: "Sandbox") { model in
                model.icon = .gitlab
                model.color = .blue
                return Sandbox().eraseToAnyView()
                
            }
        ].reversed()
        featureList.get(startIndex)?.isActive = true
    }
    
}



