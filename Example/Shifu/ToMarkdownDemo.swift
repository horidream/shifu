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
            UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .done, closure: { bar in
                m.go(-1)
            }),
            UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward"), style: .done, closure: { bar in
                m.go(1)
            }),
            UIBarButtonItem(image: UIImage(systemName: "highlighter"), style: .done, closure: { bar in
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
            UIBarButtonItem(image: UIImage(systemName: "chevron.left.forwardslash.chevron.right"), style: .done, closure: { bar in
                m.modifySelection { s in
                    ("```\n\(s)\n```", s.count + 4);
                }
            }),
            UIBarButtonItem(image: UIImage(systemName: "bold"), style: .done, closure: { bar in
                m.modifySelection { s in
                    ("**\(s)**", s.count + 2);
                }
            }),
            UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .done, closure: { bar in
                m.modifySelection { s in
                    let pre = s.count == 0 ? "## " : "\n## "
                    let suf = s.count == 0 ? "": "\n"
                    return ("\(pre)\(s)\(suf)", s.count + pre.count);
                }
            }),
            UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, closure: { bar in
                m.modifySelection { s in
                    let pre = s.count == 0 ? "- " : "\n- "
                    let suf = s.count == 0 ? "": "\n"
                    return ("\(pre)\(s)\(suf)", s.count + pre.count);
                }
            }),
            UIBarButtonItem(image: UIImage(systemName: "quote.opening"), style: .done, closure: { bar in
                m.modifySelection { s in
                    let pre = s.count == 0 ? "> " : "\n> "
                    let suf = s.count == 0 ? "": "\n\n"
                    return ("\(pre)\(s)\(suf)", s.count + pre.count);
                }
                
            }),
            UIBarButtonItem(image: UIImage(systemName: "function"), style: .done, closure: { bar in
                m.modifySelection { s in
                    let pre = s.count == 0 ? "`$$ " : "\n`$$ "
                    let suf = s.count == 0 ? " $$`": " $$`\n"
                    return ("\(pre)\(s)\(suf)", s.count + pre.count);
                }
                
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
                .border(.blue, width: 1)
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
        .onReceive(tevm.history.objectWillChange, perform: {
            updateToolbar()
        })
        .onAppear(){
            updateToolbar()
        }
        .navigationBarTitle(Text("To Markdown"))
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func updateToolbar(){
        if let toolbar = tevm.delegate?.inputAccessoryView as? UIToolbar{
            toolbar.items?.get(0)?.tintColor = tevm.hasHistory(-1) ?  nil : .gray
            toolbar.items?.get(1)?.tintColor = tevm.hasHistory(1) ? nil : .gray
        }
        
    }

}

