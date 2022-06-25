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
    let g:CGFloat = 0.98;
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var isEnterFrameActive = true
    @State var p:CGFloat = -300
    @State var v:CGFloat = 0;
    @State var r:Double = .zero
    var colors = (0..<10).map{_ in Color.random }
    var body: some View{
        
        ZStack{
            ForEach(0..<10){i in
                Image.icon(.moon_fa)
                    .frame(height: 35)
                    .rotationEffect(.degrees(r))
                    .offset(x: ((5 - i) * 40 - 20) .cgFloat, y: p)
                    .foregroundColor(colors[i])
            }
            Rectangle()
                .fill(.black)
                .frame(width: UIScreen.main.bounds.width, height:  300)
                .offset(y: 500)
        }
        .onEnterFrame(isActive: isEnterFrameActive) { f in
            v = v + g
            p = p + v
            r += 3
            if p > 300 {
                p = 300
                v *= -0.9
                if abs(v) < 0.5{
                    v = 0
                    isEnterFrameActive = false
                    clg("stop the animation")
                }
            }
            
        }
        
        .onTapGesture {
            if(!isEnterFrameActive){
                v = 0 - CGFloat.random(in: 0...100) / 100 * 50
                r = 0
                isEnterFrameActive.toggle()
            }else{
                v += v / abs(v) * CGFloat.random(in: 0...100) / 100 * 20
            }
        }
        .padding(50)
        
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

