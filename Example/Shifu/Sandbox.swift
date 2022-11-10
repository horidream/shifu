//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import ShifuWebServer
import UniformTypeIdentifiers
import CoreServices
import Combine
import PencilKit
import SwiftSoup
import VisionKit

struct Sandbox: View {

    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var isLegacySplitView = false
    @Persist("shouldShowNaivigationBar") var shouldShowNaivigationBar: Bool = true
    @State var arr = ["ShifuPasteButton", "OCR & Image Picker"]
    @State var image: UIImage? = Icons.image(.random)
    @State var isSelectingImage = false
    @State var ocrText:String = ""
    var body: some View {
        ShifuSplitView(data: $arr) { i in
            Text(i)
        } detail: { selected in

            switch selected {
            case "ShifuPasteButton":
                ZStack {
                    Toggle("Force Legacy", isOn: $isLegacySplitView)
                    ShifuPasteButton(view: {
                        Image(.paste, size: 34)
                    }, onPaste: { items in
                        clg(items)
                    }, config: { config in
                        config.forceLegacy = isLegacySplitView
                    })
                }
                .padding()
            default:
                ScrollView{
                    TextEditor(text: $ocrText)
                        .border(.blue)
                        .padding()
                        
                    (image?.sui ?? Image(.random))
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .onTapGesture {
                            isSelectingImage.toggle()
                        }
                        .onChange(of: image, perform: { newValue in
                            ShifuImageAnalyzer.scan(newValue) { text, _ in
                                if let text{
                                   ocrText = text
                                    delay(0.1){
                                        ocrText += "\n"
                                    }
                                }
                            }
                        })
                        .sheet(isPresented: $isSelectingImage) {
                            ImagePicker(sourceType: .camera, selectedImage: $image)
                                .ignoresSafeArea()
                        }
                }
            }
        } config: { config in
            config.navigationTitle = Text("Hello")
            config.navigationBarTitleDisplayMode = .automatic
            config.navigationBarHidden = (!shouldShowNaivigationBar, !shouldShowNaivigationBar)
        }
        .navigationBarHidden(shouldShowNaivigationBar)
        .navigationTitle("ShifuSplitView Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Toggle("Show Navigation Bar", isOn: $shouldShowNaivigationBar)
            }
        }
        .onInjection {
            sandbox()
        }
        .onAppear {
            sandbox()
        }

    }

    func sandbox() {
        clg(UTType.plainText.conforms(to: .plainText))
    }

}


