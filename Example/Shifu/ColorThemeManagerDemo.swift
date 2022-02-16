//
//  ColorThemeManagerDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Shifu
import SwiftUI



struct ColorThemeManagerDemo:View{
    @State var source:String = ""
    @State var height: CGFloat = 0
    @EnvironmentObject var colorManager: ColorSchemeMananger
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        ScrollView{
            Picker("", selection: $colorManager.colorScheme){
                Text("Light").tag(ColorSchemeMananger.ColorScheme.light)
                Text("Dark").tag(ColorSchemeMananger.ColorScheme.dark)
                Text("System").tag(ColorSchemeMananger.ColorScheme.unspecified)
            }
            .pickerStyle(.segmented)
            .padding()
            
            Image(systemName: "helm")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
                .background(Color.yellow)
                .cornerRadius(15)
                .padding()
                .onTapGesture {
                    sc.emit("contentHeight", userInfo: ["value": CGFloat(Int.random(in: 100...300))])
                }
            
            MarkdownView(viewModel:ShifuWebViewModel(), content: $source, allowScroll: false)
                .autoResize($height)
//                .frame(height: height)
                .padding()
//                .on("contentHeight"){
//                    if let height = $0.userInfo?["value"] as? CGFloat{
//                        clg("will set content height to \(height)")
//                        self.height = height
//                    }
//                }
            
        }
        
        .onAppear(perform: {
            if let content = Bundle.main.url(forResource: "source/ColorThemeManagerDemo", withExtension: "md")?.content
            {
                source = content
            }
        })
        .navigationTitle("ColorThemeManager Demo")
        .navigationBarTitleDisplayMode(.inline)
        .onInjection {
            
        }
    }
}
