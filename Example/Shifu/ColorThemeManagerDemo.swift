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
    @State var sourceViewHeight:CGFloat = 0
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
            
            MarkDownView(content: $source)
                .frame(height: sourceViewHeight)
            
        }
        .on("scrollHeight"){
            if let height = $0.userInfo?["value"] as? CGFloat{
                clg(height)
                sourceViewHeight = height + 80
            }
        }
        .onAppear(perform: {
            if let content = Bundle.main.url(forResource: "source/ColorThemeManagerDemo", withExtension: "md")?.content
            {
                source = content
            }
        })
        .onInjection {
            
        }
    }
}
