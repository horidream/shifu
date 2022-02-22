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
    @EnvironmentObject var colorManager: ColorSchemeMananger
    @ObservedObject private var injectObserver = Self.injectionObserver
    @ObservedObject var webViewModel = ShifuWebViewModel()
    
    var scrollView:some View{
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
            
            MarkdownView(viewModel: webViewModel,  content: $source, allowScroll: false)
                .autoResize()
                .padding()
        }
        .onAppear(perform: {
            if let content = Bundle.main.url(forResource: "source/ColorThemeManagerDemo", withExtension: "md")?.content
            {
                source = content
            }
        })
        
    }
    
    var body: some View{
        scrollView
            .navigationTitle("ColorThemeManager Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        webViewModel.action = .snapshot()
                    }
                     label: {
                        Image(systemName: "camera")
                    }

                }
            }
        .onInjection {
            
        }
    }
}
