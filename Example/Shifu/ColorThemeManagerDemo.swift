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
    @EnvironmentObject var colorManager: ColorSchemeMananger
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var webViewModel:ShifuWebViewModel = .markdown
    
    var scrollView:some View{
        ScrollView{
            Picker("", selection: $colorManager.colorScheme){
                Text("Light").tag(ColorSchemeMananger.ColorScheme.light)
                Text("Dark").tag(ColorSchemeMananger.ColorScheme.dark)
                Text("System").tag(ColorSchemeMananger.ColorScheme.unspecified)
            }
            .pickerStyle(.segmented)
            .padding()
            
            
            MarkdownView(viewModel: webViewModel,  content: .constant("@source/ColorThemeManagerDemo.md".url?.content ?? ""))
                .autoResize()
                .padding()
        }
    }
    
    var body: some View{
        scrollView
            .navigationTitle("ColorThemeManager Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        webViewModel.exec(.snapshot())
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
