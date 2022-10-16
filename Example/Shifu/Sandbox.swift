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
    @Environment(\.dismiss) var dismiss
    @ThemedColor(light: .black, dark: .white) var foregroundColor
    @ThemedColor(light: .white, dark: .black) var backgroundColor
    @State var shouldCompress: Bool = false
    @State var item:PreviewItem? = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@web/icon.png".url)
    @State var pinned = false
    @State var alpha: CGFloat = 1
    @StateObject var reachableChecking = SiteRechableChecking(sites: ["www.google.com", "www.facebook.com"])
    
    var body: some View {
        return ZStack{
            //                Preview(item: $item, pinned: $pinned)
            if reachableChecking.isAvailable {
                if item?.isText ?? false{
                    PreviewText(item: $item)
                } else {
                    PreviewQL(item: $item)
                }
                
            } else {
                Text("Site is not available")
            }
        }
        //        .navigationBarHidden(true)
        .ignoresSafeArea()
        .opacity(alpha)
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                
                
                
                    Button{
                        pinned.toggle()
                        self.item?.isLocked = pinned
                    } label: {
                        Image.icon(pinned ? .lockFill : .lock_sf, size: 20)
                    }
                    .disabled(item == nil)
                Button{
                    if item == nil {
                        item = with("".data(using: .utf8)?.previewItem(for: .plainText)){
                            $0?.isLocked = pinned
                        }
                    } else {
                        item = nil
                    }
                    
                } label: {
                    item == nil  ? Image.icon(  .plusSquareFill , size: 20)
                        .frame(width: 22)
                    : Image.icon(  .trashFill , size: 18).frame(width: 22)
                }
                
                ShifuPasteButton (view: {
                    Image.icon(.plus_fa, size: 24)
                        .foregroundColor(.blue)
                }, onPaste: { items in
                    guard !pinned else { return }
                    item = pb.previewItem(for: allowedDataTypes)
                }, shouldCompress: $shouldCompress)
                
            }
        })
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        //        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    func sandbox(){
        
    }
}

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .image,.tiff,  .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]





