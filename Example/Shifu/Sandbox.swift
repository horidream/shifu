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
    @State var item = PreviewItem("\(Shifu.bundle.bundleIdentifier!)@web/icon.png".url)
    var body: some View {
        ZStack{
            Preview(item: $item)
            if #available(iOS 16, *){
                PasteButton(supportedContentTypes: allowedDataTypes){_ in

                    item = PreviewItem(pb.previewURL(for: allowedDataTypes))
                }
            }

        }

        
//            .overlay{
//                if #available(iOS 16, *){
//                    PasteButton(supportedContentTypes: allowedDataTypes.map(\.identifier)){_ in
//
//                        item = PreviewItem(pb.previewURL(for: .utf8PlainText))
//                    }
//                } else {
//                    Color.red
//                }
//            }
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
        item = pb.previewItem(for: allowedDataTypes)
    }
}

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .tiff, .image, .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]







