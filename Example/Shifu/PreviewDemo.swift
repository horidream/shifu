//
//  PreviewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/10/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import UniformTypeIdentifiers

struct PreviewDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var previewItem:PreviewItem? = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@/web/icon.png".url)
    @State var isPasteboardPinned = false
    var noItem:Bool {
        previewItem?.previewItemURL == nil
    }
    var body: some View {
        let item = previewItem
        PreviewShifu(item: $previewItem, pinned: $isPasteboardPinned)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Button{
                        isPasteboardPinned.toggle()
                    } label: {
                        Image.resizableIcon(isPasteboardPinned ? .lockFill : .lock_sf, size: 15)
                            .scaleEffect(0.7)
                    }
                    .disabled(item == nil)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if noItem {
                        Button{
                            previewItem = PreviewItem("".data(using: .utf8)?.previewURL(for: .plainText))
                        } label: {
                            Image.resizableIcon(  .plus_sf , size: 20)
                                .frame(width: 22)
                        }

                    } else {
                        Button{
                            previewItem = nil
                            pb.setPreviewItem(nil)
                        } label: {
                            Image.resizableIcon(  .trashFill , size: 20)
                                .frame(width: 22)
                        }
                    }
                }

                PasteButton

            })
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .onInjection{
                sandbox()
            }
            .onAppear{
                sandbox()
            }
    }
    
    // for the future feature, not used yet
    var PasteButton:ToolbarItemGroup<ShifuPasteButton<some View>>{
        ToolbarItemGroup(placement: .navigationBarTrailing){
            ShifuPasteButton (view: {
                Image.resizableIcon(.plus_fa, size: 24)
                    .foregroundColor(.blue)
            }, onPaste: { items in
                guard !isPasteboardPinned else { return }
                previewItem = pb.previewItem(for: allowedDataTypes)
            })
            
        }
    }
    
    func sandbox(){
    }
}


private let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .image,.tiff,  .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]
