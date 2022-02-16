//
//  WebViewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu


struct WebViewDemo:View{
    @State var content:String = ""
    @State var markdownHeight:CGFloat = 0
    @EnvironmentObject var vm:HomeViewModel
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        let md = MarkdownView(content: $content)
        return VStack{
            md
//                .frame(height: markdownHeight)
                .padding()
            TextEditor(text: $content)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .border(Color.blue, width: 1)
                .padding()
            
            
        }
        .navigationTitle("Markdown in Shifu")
        .navigationBarTitleDisplayMode(.inline)
        .on("contentHeight".toNotificationName()){
            if let height = $0.userInfo?["value"] as? CGFloat{
                withAnimation(.easeIn(duration: 0.87)) {
                    markdownHeight = height
                    
                }
            }
        }
        .on("example".toNotificationName(), { notification in
            if let content = notification.userInfo?["content"] as? String{
                self.content = content
            }
        })
        .onInjection {
            
        }
    }
}
