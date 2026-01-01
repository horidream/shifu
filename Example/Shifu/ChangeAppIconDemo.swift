//
//  ChangeAppIconDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct ChangeAppIconDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var iconName:String?  = UIApplication.shared.alternateIconName {
        didSet{
            UIApplication.shared.setAlternateIconName(iconName){
                clg($0 as Any)
            }
        }
    }
    var body: some View {
        VStack{
            Text("Change Your App Icon")
                .bold()
                .font(.title)
            Text("Current: \(iconName ?? "Default")")
                .font(.caption)
                .foregroundColor(.secondary)
            Image(iconName ?? "AppIconImage", bundle: nil)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 2)
                }
                .onTapGesture {
                    iconName = iconName == nil ? "Chunli" : nil
                    
                }
            ScrollView(showsIndicators: false){
                SimpleMarkdownViewer(path: "@/source/ChangeIconDemo.md", animated: true, css: "h2{text-align: center;}")
            }.padding()
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
    }
}
