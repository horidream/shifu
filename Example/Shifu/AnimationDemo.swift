//
//  AnimationDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct AnimationDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var props = TweenProps()
    @State var count = 0;
    var body: some View{
        ZStack{
            props.apply{
                VStack{
                    Image.icon(.swift_fa, size: 100)
                        .foregroundColor(.orange)
                    SimpleMarkdownViewer(content: "### May the `Force` be with you.\n" + #"""
                                 **May the Force be with you** was a phrase used to wish an individual or group good luck or good will, one that expressed the speaker's wish that the Force work in the favor of the addressee. The phrase was often used as individuals parted ways or in the face of an impending challenge.
                                 """#, css: "h3, * { text-align: center; line-height: 25px;} ")
                    .id(injectObserver.injectionNumber)
                    .frame(height: 200)
                }
                .padding(50)
            }
            
            if(count % 2 == 1){
                ScrollView{
                    SimpleMarkdownViewer(content: "@source/AnimationDemo.md".url?.content ?? "## Hello", css: "body, pre { margin: 0; border: none; box-shadow: none; } ")
                }
                .transition(.opacity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            if count % 2 == 1 {
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
            \.scale: 4,
             \.rotationY : -255,
             \.alpha: 0
        ], duration: 0.5);
    }
}

