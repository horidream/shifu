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
    var noItem:Bool {
        item == nil
    }
    var body: some View {
        SiteReachableView(sites: ["www.google.com", "www.facebook.com"]) {
            Text("good")
        } fallbackViewBuilder: {
            Text("bad")
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        
        
    }
    
    func sandbox(){
        let s = "https://thisanimedoesnotexist.ai/results/psi-1.0/seed\(String(format: "%05d", (1...99999).randomElement()!)).png"
        clg(s)
    }
}

let allowedDataTypes: [UTType] = [.utf8PlainText, .plainText, .image,.tiff,  .png, .jpeg, .gif, .bmp, .ico, .pdf, .doc, .excel, .docx, .xlsx]





