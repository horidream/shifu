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
import ShifuLottie





struct Sandbox:View{
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = "\u{f6d3}".attributedString()
    @PersistToFile("a.txt") var n:String
    let layout = [GridItem(.adaptive(minimum: 60))]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout) {
                ForEach(Icons.Name.allCases.filter{ $0.isFontAwesome }.shuffled()[...99], id: \.self) { name in
                    Icons.outlineImage(name, color: name.isFontAwesome ? .red : .blue, width: 1).sui
                }
                
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
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



@propertyWrapper
struct log<T>{
    var wrappedValue: T{
        didSet{
            clg(wrappedValue)
        }
    }
    
}

class Test{
    @log var name = "Baoli"
}
