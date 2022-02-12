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
    @EnvironmentObject var vm:HomeViewModel
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        let md = MarkDownView(content: $content)
        return VStack{
            md
            TextEditor(text: $content)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .border(Color.blue, width: 1)
                .padding()
            
            
        }
        .navigationTitle("Mark Down in Shifu")
        .navigationBarTitleDisplayMode(.inline)
        
        .on("mounted".toNotificationName(), { notification in
            if let content = notification.userInfo?["content"] as? String{
                self.content = content
            }
        })
        .onInjection {
            
        }
    }
}
