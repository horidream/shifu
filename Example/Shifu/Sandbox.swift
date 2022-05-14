//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var content = "# haha"
    @State var datasource:UITableViewDiffableDataSource<String, String>!
    var body: some View{
        VStack(){
            SimpleMarkdownViewer(content: content)
                .id(content)
                .padding()
            
            Spacer()
            Circle()
                .aspectRatio(0.73, contentMode: .fit)
                .foregroundColor(.red)
                .padding()

        }
        .navigationTitle("Sandbox")
        .debug {
            clg("OK")
        }
        
    }
}




