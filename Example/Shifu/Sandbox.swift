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
    @State var pinned = false
    @State var alpha: CGFloat = 1
    @StateObject var reachableChecking = SiteRechableChecking(sites: ["www.google.com", "www.facebook.com"])
    
    var shouldEditText: Bool {
        if let identifier = item?.typeIdentifier, let type = UTType(identifier), type.conforms(to: .text){
            return true
        } else {
            return false
        }
        
    }
    var body: some View {
        return ZStack{
//            if shouldEditText{
//                PreviewText(item: $item, pinned: $pinned)
//            } else {
//                PreviewQL(item: $item, pinned: $pinned)
//            }
            if reachableChecking.isAvailable {
                Preview(item: $item, pinned: $pinned)
                
            } else {
                Text("Site is not available")
            }
        }
        .onTapGesture {
            reachableChecking.check()
        }
//        .navigationBarHidden(true)
        .ignoresSafeArea()
        .opacity(alpha)
//        .toolbar(content: {
//            ToolbarItem(placement: .navigationBarLeading) {
//
//                Button{
//                    item =  hasNoContent ? "".data(using: .utf8)?.previewItem(for: .plainText) : nil
//                } label: {
//                    Image.icon( hasNoContent ? .plus_fa : .trashFill, size: 18)
//                }
//            }
//            ToolbarItem(placement: .navigationBarLeading) {
//                if item != nil {
//                    Button{
//                        delay(0.01){
//                            pinned.toggle()
//                        }
//                    } label: {
//                        Image.icon(pinned ? .lockFill : .lock_sf, size: 20)
//                    }
//                }
//
//            }
//            ToolbarItem {
//                ShifuPasteButton (view: {
//                    Image.icon(.plus_fa, size: 24)
//                        .foregroundColor(.blue)
//                }, onPaste: { items in
//                    guard !pinned else { return }
//                    item = pb.previewItem(for: allowedDataTypes)
//                }, shouldCompress: $shouldCompress)
//
//            }
//        })
        .onChange(of: reachableChecking.isAvailable, perform: { newValue in
            clg("feature available: ", newValue)
        })
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    func sandbox(){
        
    }
}

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .image,.tiff,  .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]





