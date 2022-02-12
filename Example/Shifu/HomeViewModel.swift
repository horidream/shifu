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

//func cast<T:AnyObject>(publisher: Published<T>.Publisher)->Binding<T>{
//    return Binding {
//        return publisher
//    } set: {
//        <#code#>
//    }
//
//}

class HomeViewModel: ObservableObject{
    @Published var featureList:[FeatureViewModel<AnyView>] = []
    @Published var script:String = ""
    init(){
        refresh()
    }
    
    func refresh(){
        featureList = [
            FeatureViewModel(name: "Markdown", viewBuilder: { model in
                return WebViewDemo().eraseToAnyView()
                
            }),
            FeatureViewModel(name: "Image", viewBuilder: { _ in
                Image(systemName: "helm")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(15)
                    .eraseToAnyView()
            })
        ]
    }
    
}
