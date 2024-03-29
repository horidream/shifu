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

struct ShifuSplitViewDemo: View {

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
                SimpleMarkdownViewer(content: "## hello world", css: "h2{ font-size: 4rem; color: gold; text-align: center; line-height: 88px;}")
                    .id(injectObserver.injectionCount)
                
            default:
                ScrollView{
                    TextEditor(text: $ocrText)
                        .border(.blue)
                        .padding()
                        
                    (image?.sw ?? Image(.random))
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

    }

}


