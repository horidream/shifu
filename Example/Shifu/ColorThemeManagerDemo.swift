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
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var webViewModel:ShifuWebViewModel = .markdown
    @StateObject var screenShotModel:ShifuWebViewModel = .markdown
    
    var scrollView:some View{
        ScrollView{
            ThemePicker()
                .padding()
            
            MarkdownView(viewModel: webViewModel,  content: .constant("@source/ColorThemeManagerDemo.md".url?.content ?? ""))
                .autoResize()
                .padding()
        }
    }
    
    var body: some View{
        ZStack{
            MarkdownView(viewModel: screenShotModel,  content: .constant("@source/ColorThemeManagerDemo.md".url?.content ?? ""))
                .autoResize()
                .opacity(0)
                .frame(width: 960)
            scrollView
                .frame(width: UIScreen.main.bounds.size.width)
        }
        
        .navigationTitle("ColorThemeManager Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    screenShotModel.exec(.snapshot())
                } label: {
                    Image(systemName: "camera")
                }
            }
        }
        .onInjection {
            
        }
    }
}
