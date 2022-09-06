//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

struct Sandbox: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var iconName:String?  = UIApplication.shared.alternateIconName {
        didSet{
            UIApplication.shared.setAlternateIconName(iconName)
        }
    }
    var body: some View {
        VStack{
            Text("Current App Icon: \(iconName ?? "Default")")
            Image(named: iconName ?? "AppIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .mask {
                    RoundedRectangle(cornerRadius: 20)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 2)
                }
        }
        .onTapGesture {
            iconName = iconName == nil ? "Chunli" : nil
            
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        clg(Bundle.main.infoDictionary?["CFBundleIcons"])
    }
}


