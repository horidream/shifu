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
    @State var shouldCompress: Bool = false
    @State var item:PreviewItem? = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@web/icon.png".url)

    var body: some View {
        return ZStack{
            Preview(item: $item, config: with(Preview.Config()){
                $0.shouldAutoUpdatePasteboard = true
            })
        }
        .toolbar(content: {
            ToolbarItem {
                ShifuPasteButton (view: {
                    Image.icon(.plus_fa, size: 24)
                        .foregroundColor(.blue)
                }, onPaste: { items in
                    item = pb.previewItem(for: allowedDataTypes)
                }, shouldCompress: $shouldCompress)
                
            }
            ToolbarItem(placement: .bottomBar) {
                Toggle("Should Compress Content", isOn: $shouldCompress)
                    .toggleStyle(.switch)
            }
        })
//        .onChange(of: item, perform: { newValue in
//            pb.setPreviewItem(item)
//        })
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

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .image,.tiff,  .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]







