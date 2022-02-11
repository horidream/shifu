//
//  WebViewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu


func escape(_ str:String)->String{
    return str
        .replacingOccurrences(of: "\\",with: "\\\\")
        .replacingOccurrences(of: "\n",with: "\\n")
        .replacingOccurrences(of: "\r",with: "\\r")
        .replacingOccurrences(of: "\t",with: "\\t")
        .replacingOccurrences(of: "\"",with: "\\\"")
        .replacingOccurrences(of: "\'",with: "\\\'")
    
}


struct WebViewDemo:View{
    @State var script = ""
    @State var markdownText = ""
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        VStack{
            MarkDownView(script: $script)
            TextEditor(text: $markdownText)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .border(Color.blue, width: 1)
                .padding()
                
                
        }
            .navigationTitle("Mark Down in Shifu")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: markdownText) { newValue in
                script = "m.vm.content = \"\(escape(newValue))\";"
            }
            .on("mounted".toNotificationName(), { notification in
                if let content = notification.userInfo?["content"] as? String{
                    markdownText = content
                }
            })
            .onInjection {
                
            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//
//                        clg("will execute the script \(editingScript)")
//                        script = editingScript
//                        editingScript = ""
//
//                    }) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
            
    }
}
