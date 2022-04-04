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

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        VStack(){
            SimpleMarkdownViewer(content: "## Hello World \n> Stay Hungry, Stay Foolish")
                .padding()
            Circle()
                .foregroundColor(.red)
                .padding()
                .onTapGesture {
//                    let alert = UIAlertController(title: "Hello", message: "This is the test", preferredStyle: .alert)
//                    rootViewController.present(alert, animated: true)
//                    delay(3) {
//                        alert.dismiss(animated: true)
//                    }
                    
                    let parent = rootViewController.view!
                    parent.viewWithTag(999)?.removeFromSuperview()
                    let view = UIView(frame: .zero)
                    view.tag = 999
                    view.backgroundColor = .random
                    view.add(to: parent)
                    view.quickAlign().quickSize(nil, 64).quickMargin(nil, 18, nil, 40)

                    
                }
            Spacer()
        }
        .navigationTitle("Sandbox")
        .onInjection {
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    
    
    func sandbox(){
        let a = Test()
        let b = Test()
        b.a = 99
        clg(a.merge(b).merge(#"{"a": 73}"#).stringify())
        
    }
}

class Test: JsonMergeable{
    var a:Int? = 10
    @CodableColor public var color = .red.withAlphaComponent(0.3)
}



