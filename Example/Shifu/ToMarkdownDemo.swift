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
    @StateObject private var tevm = ShifuTextEditor.ViewModel{ m in
        m.inputAccessoryItems = [
            UIBarButtonItem(title: "`", style: .done, closure: { bar in
                if let txt = m.delegate?.text, let selectedRange = m.delegate?.selectedRange{
                    let p1 = txt.substring(0, selectedRange.lowerBound)
                    let p2 = txt.substring(selectedRange.lowerBound, selectedRange.upperBound)
                    let p3 = txt.substr(selectedRange.upperBound)
                    m.update(text:  p1 + "`\(p2)`" + p3)
                    delay(0.01){
                        m.delegate?.selectedRange = NSMakeRange(p1.count + p2.count + 1, 0)
                    }
                }
            }),
            UIBarButtonItem(title: "```", style: .done, closure: { bar in
                if let txt = m.delegate?.text, let selectedRange = m.delegate?.selectedRange{
                    let p1 = txt.substring(0, selectedRange.lowerBound)
                    let p2 = txt.substring(selectedRange.lowerBound, selectedRange.upperBound)
                    let p3 = txt.substr(selectedRange.upperBound)
                    m.update(text:  p1 + "```\n\(p2)\n```" + p3)
                    delay(0.01){
                        m.delegate?.selectedRange = NSMakeRange(p1.count + p2.count + 4, 0)
                    }
                }
            }),
            UIBarButtonItem(title: "**", style: .done, closure: { bar in
                if let txt = m.delegate?.text, let selectedRange = m.delegate?.selectedRange{
                    let p1 = txt.substring(0, selectedRange.lowerBound)
                    let p2 = txt.substring(selectedRange.lowerBound, selectedRange.upperBound)
                    let p3 = txt.substr(selectedRange.upperBound)
                    let range = m.delegate?.selectedRange
                    m.update(text:  p1 + "**\(p2)**" + p3)
                    delay(0.01){
                        m.delegate?.selectedRange = NSMakeRange(p1.count + p2.count + 2, 0)
                    }
                }
            }),
            UIBarButtonItem(title: "##", style: .done, closure: { bar in
                if let txt = m.delegate?.text, let selectedRange = m.delegate?.selectedRange{
                    
                    let p1 = txt.substring(0, selectedRange.lowerBound)
                    let p2 = txt.substring(selectedRange.lowerBound, selectedRange.upperBound)
                    let p3 = txt.substr(selectedRange.upperBound)
                    
                    m.update(text:  p1 + "## \(p2)\(selectedRange.length == 0 ? "": "\n")" + p3)
                    delay(0.01){
                        m.delegate?.selectedRange = NSMakeRange(p1.count + p2.count + 3, 0)
                    }
                }
            }),
            UIBarButtonItem(image: UIImage(systemName: "chevron.left.forwardslash.chevron.right"), style: .done, closure: { bar in
                clg("nice")
            })

        ]
    }
    var body: some View {
        VStack{
            ThemePicker()
                .padding(.horizontal)
            MarkdownView(viewModel: vm, content: $tevm.text)
                .padding(8)
                .border(Color.red)
                .padding(.horizontal)
            ShifuTextEditor(viewModel: tevm)
                .disableAutocorrection(true)
                .padding(8)
                .border(Color.blue, width: 1)
                .padding(.horizontal)

            Button {
                if let content:String  = pb.html{
                    vm.apply("return toMarkdown(content)", arguments: ["content": content]){
                        if case .success(let md) = $0, let md = md as? String {
                            self.tevm.text = md
                        }
                    }
                }else{
                    self.tevm.text = pb.string ?? ""
                }
            } label: {
                Text("Transform to Markdown")
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    UIPasteboard.general.string = self.tevm.text
                }
            label: {
                Image(systemName: "doc.on.doc")
            }
                
            }
        })
        .navigationBarTitle(Text("To Markdown"))
        .navigationBarTitleDisplayMode(.inline)
        
    }
    

}

