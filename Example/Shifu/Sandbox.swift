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
    @State var pinned = true
    @State var alpha: CGFloat = 1
    var body: some View {
        return ZStack{
            Preview(item: $item, pinned: $pinned, config: with(Preview.Config()){
                $0.shouldAutoUpdatePasteboard = true
            })
            .opacity(alpha)
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
            ToolbarItem(placement: .bottomBar) {
                Image.icon(.comment)
                    .onTapGesture {
                        ta($alpha).to(0.001).delay(2).to( 1, duration: 1)
                    }
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
        let a = "".data(using: .utf8)?.previewURL(for: .plainText)
        let b = "".data(using: .utf8)?.previewURL(for: .plainText)
        clg(a == b)
    }
}

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .image,.tiff,  .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]






