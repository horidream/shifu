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
    @State var image: UIImage? = Icons.uiImage(.random)
    @State var isSelectingImage = false
    @State var shouldHideContent = false
    @State var ocrText:String = ""
    @Tween var tween
    var body: some View {
        ShifuSplitView(data: $arr) { i in
            Text(i)
                .if(shouldHideContent){
                    $0.redacted(reason: .placeholder)
                }
                
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
                SubscriptionView(content: Text("sub"), publisher: DisplayLink.shared) { f in
//                    clg(f)
                }
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
        .tweenProps(tween)
        .navigationBarHidden(shouldShowNaivigationBar)
        .navigationTitle("ShifuSplitView Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Toggle("Show Navigation Bar", isOn: $shouldShowNaivigationBar)
            }
            ToolbarItem(placement: .bottomBar) {
                Button{
                    tl($tween)
                        .to([\.alpha: 0, \.x: -30])
                        .perform{
                            self.shouldHideContent.toggle()
                        }
                        .set([\.alpha: 0, \.x: 30])
                        .delay(0.3)
                        .to([\.alpha: 1, \.x: 0 ])
                } label: {
                    Text("\(shouldHideContent ? "Hide" : "Show") Content")
                }
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
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes.baseAddress!)
        }
        clg(key.map{ String(format: "%02hhx", $0) }.joined() )
        
        let memory = MemoryLayout<CChar>.self
        clg(memory.size)
        clg(memory.stride)
        clg(memory.alignment)
    }

}




struct Chess{
    var player1: Int64
    var player2: Int32
    var win: Bool
}
