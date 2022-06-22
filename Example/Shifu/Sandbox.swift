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
    @StateObject var props = TweenProps()
    @State var count = 0;
    var body: some View{
        VStack{
            Image.icon(.swift_fa, size: 100)
                .foregroundColor(.orange)
            SimpleMarkdownViewer(content: "### I want to say thank you for your hard work.\n May the `force` be with you.", css: "h3, * { text-align: center; line-height: 25px;} ")
                .id(injectObserver.injectionNumber)
        }
            .padding(50)
            .tweenProps(props)
            .onTapGesture {
                if count % 2 == 0 {
                    tween($props,
                          from: [
                            \.x: -300,
                             \.rotationY: 89,
                          ],
                          to: [
                            \.x: 0,
                             \.rotationY: 0,
                             \.alpha: 1
                          ],
                          type: .back);
                }else{
                    tween($props,
                          to: [
                            \.x: 300,
                             \.rotationY: -89,
                             \.alpha: 0.002
                          ]
                          );
                    
                }
                count += 1
                
            }
            .onInjection{
                sandbox()
            }
            .onAppear{
                sandbox()
            }
    }

    func sandbox(){
        tween($props, from: [
            \.y : 400,
             \.alpha: 0
        ]);
    }
    
    func value<T>(for keyPath: ReferenceWritableKeyPath<TweenProps, T>)-> T {
        return props[keyPath:keyPath]
    }
}




