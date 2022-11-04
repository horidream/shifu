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

struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var isLegacySplitView = false
    @Persist("shouldShowNaivigationBar") var shouldShowNaivigationBar:Bool = true
    @ObservedObject var b: BBB = BBB()
    @State var arr = ["1","2","3"]
    var body: some View {
        ShifuSplitView(data: $arr) { i in
            Text(i)
        } detail: { selected in
            
            switch selected {
            case "1":
                ZStack{
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
                Text("You selecrted \(selected ?? "nothing" )")
            }
        } config: { config in
            config.navigationTitle = Text("Hello")
            config.navigationBarTitleDisplayMode = .automatic
            config.navigationBarHidden = (!shouldShowNaivigationBar, !shouldShowNaivigationBar)
        }
        .navigationBarHidden(shouldShowNaivigationBar)
        .navigationTitle("ShifuSplitView Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                Toggle("Show Navigation Bar", isOn: $shouldShowNaivigationBar)
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
        clg(b.a)
        b.a = 12
        clg(b.a)
        
    }
    
}

class BBB: ObservableObject{
    @AAA var a = 11
}

@propertyWrapper public class AAA<T:Codable>: DynamicProperty{
    private var value:T
    public var wrappedValue:T{
        get{
            return value
        }
        set{
            value = newValue
        }
    }
    
    public var projectedValue: Binding<T>{
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    public init(wrappedValue: T){
        value = wrappedValue
    }
}
extension Person: JsonMergeable{}
