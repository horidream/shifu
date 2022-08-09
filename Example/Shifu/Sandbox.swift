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
import Lottie



func addAnimation(_ layer: CALayer){
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.fromValue = 0
    animation.toValue = Double.pi * 2
    animation.duration = 1
    animation.repeatCount = .infinity
    animation.isRemovedOnCompletion = true
    layer.removeAllAnimations()
    layer.add(animation, forKey: "rotation")
    
}

struct Sandbox:View{
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.locale) var locale: Locale
    @ObservedObject private var injectObserver = Self.injectionObserver
    @PersistToFile("a.txt") var n:String
    @State var currentValue:CGFloat = 0
    @State var lottieAnimation = AnimationView(name: "lottie_example")
    @State var v = with(UIView()){ v in
        v.layer.backgroundColor = .blue
        addAnimation(v.layer)
        v.layer.speed = 0
    }
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    let layout = [GridItem(.adaptive(minimum: 60))]
    
    
    var body: some View {
        ScrollView{
            
            ContainerUIView(v)
                .frame(width: 50, height: 50)
                .offset(offset)
                .gesture(DragGesture()
                    .onChanged{ value in
                        offset = lastOffset + CGSize(value.translation.width, value.translation.height)
                    }
                    .onEnded{ value in
                        lastOffset = offset
                    }
                )
            Text("\(currentValue)")
            Slider(value: $currentValue, in: 0...1).padding()
        }
        .onChange(of: currentValue, perform: { newValue in
            if (currentValue == 1){
                v.layer.speed = 1
            } else {
                if( v.layer.speed == 1) {
                    v.layer.speed = 0
                    v.layer.beginTime = 0
                }
            }
            v.layer.timeOffset = currentValue
        })
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            lottieAnimation.play(fromProgress: 0.8, toProgress: 0)
            sandbox()
        }
    }
    
    func sandbox(){
        
        clg((1..<10).ns)
        clg((1...10).ns)
    }
    
}




class MyView: UITableView,UIScrollViewDelegate{
    var offset:CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offset = scrollView.contentOffset.y + scrollView.contentInset.top
    }
    @objc func onRefresh(_ refresh: UIControl){
        clg("changed")
    }
}


