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

    var body: some View {
        VStack{
            if #available(iOS 16.0, *) {
                PasteButton(supportedContentTypes: [.image, .text], payloadAction: { providers in
                    clg(providers)
                })
                ShifuPasteButton(view: {
                    Image.icon(.swift_sf)
                        .foregroundColor(.white)
                        .padding(12)
                }, foregroundColor: .blue,  onPaste: {
                    clg($0)
                })
                .frame(width: 100, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Button{
                    UIApplication.shared.open(UIApplication.openSettingsURLString.url!)
                    
                    clg(UIApplication.openSettingsURLString)
                } label: {
                    Text("Settings")
                }
            }
            
            
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
//        NSMapTable<NSObject, NSObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)
        
    }
}










