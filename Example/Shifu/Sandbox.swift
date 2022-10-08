//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import UniformTypeIdentifiers
import CoreServices
import Combine

struct Sandbox: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ThemedColor(light: .black, dark: .white) var foregroundColor
    @ThemedColor(light: .white, dark: .black) var backgroundColor
    @State var a = "a".ps
    @State var b = "b".ps
    @State var item:PreviewItem? = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@web/icon.png".url)

    var body: some View {
        let _ = a.merge(with: b)
            .sink { l in
                clg(l)
            }.retainSingleton()
        return ZStack{
            Preview(item: $item, config: with(Preview.Config()){
                $0.shouldAutoUpdatePasteboard = false
            })
        }
        .toolbar(content: {
            ToolbarItem {
                ShifuPasteButton (view: {
                    Image.icon(.plus_fa, size: 24)
                        .foregroundColor(.blue)
                }, onPaste: { items in
                    item = pb.previewItem(for: allowedDataTypes)
                })
                
            }
            ToolbarItem {
                if #available(iOS 16, *){
                    PasteButton(supportedContentTypes: [.data]) { _ in
                        item = pb.previewItem(for: allowedDataTypes)
                    }
                    
                }
            }
            

        })
        .onChange(of: item, perform: { newValue in
            pb.setPreviewItem(item)
        })
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
    }
    
    func sandbox(){
        
    }
}

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .tiff, .image, .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]







