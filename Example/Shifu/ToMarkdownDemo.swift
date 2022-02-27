//
//  ToMarkdownDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import CoreServices

struct ToMarkdownDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var vm = ShifuWebViewModel.markdown
    @State var content:String = ""
    var body: some View {
        
        VStack{
            MarkdownView(viewModel: vm, content: $content)
                .padding(8)
                .border(Color.red)
                .padding(.horizontal)
            TextEditor(text: $content)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .padding(8)
                .border(Color.blue, width: 1)
                .padding(.horizontal)

            Button {
                if let content:String  = pb.html{
                    vm.apply("return toMarkdown(content)", arguments: ["content": content]){
                        if case .success(let md) = $0, let md = md as? String {
                            UIPasteboard.general.string = md
                            self.content = md
                        }
                    }
                }else{
                    content = pb.string ?? ""
                }
            } label: {
                Text("Transform to Markdown")
            }
        }
        .navigationBarTitle(Text("To Markdown"))
        .navigationBarTitleDisplayMode(.inline)
        
    }
    

}

