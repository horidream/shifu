//
//  OnEnterFrameDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/6/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit



let bounds = UIScreen.main.bounds.offsetBy(dx: -UIScreen.main.bounds.width/2, dy: -UIScreen.main.bounds.height/2).insetBy(dx: 0, dy: 68)
struct OnEnterFrameDemo:View{
    let g:CGFloat = 0.98;
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var isEnterFrameActive = true
    @State var shouldShowCode  = true
    @StateObject var props = TweenProps()
    @StateObject var balls = Balls()
    @Namespace var animation
    var body: some View{
        Group{
            if !shouldShowCode {
                ScrollView{
                    SimpleMarkdownViewer(content: "@source/OnEnterFrameDemo.md".url?.content ?? "", animated: false,  css: "pre { border: none; }")
//                        .id(injectObserver.injectionCount)
                }
            } else{
                ZStack{
                    ForEach(balls.balls, id: \.self){ b in
                        ZStack{
                            Circle()
                                .frame(height: 200)
                                .foregroundColor(b.color)
                            Circle()
                                .frame(width: 50, height: 30)
                                .scaleEffect(x: 2)
                                .rotationEffect(.degrees(-42))
                                .foregroundColor(.white)
                                .offset(x:-50, y:-50)
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .offset(x:-75, y:-10)
                        }
                        .scaleEffect(b.size / 200)
                        .offset(x: b.position.x, y: b.position.y)
                        
                    }
                    Rectangle()
                        .fill(.black)
                        .frame(width: UIScreen.main.bounds.width, height:  300)
                        .offset(y: 544)
                }
                .onTapGesture {
                    balls.balls.filter{ $0.isStill }.forEach { b in
                        b.v = .random(in: .zero.insetBy(dx: -10, dy: -30))
                    }
                }
                .onEnterFrame(isActive: isEnterFrameActive) { f in
                    balls.balls.forEach { b in
                        b.update()
                    }
                    balls.updatedCount += 1
                }
                .padding(50)
            }
        }
        .tweenProps(props)
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    isEnterFrameActive = !shouldShowCode
                    tween($props, from:[\.y : 0, \.alpha: 1], to: [\.y : 500, \.alpha: 0 ])
                    delay(0.2){
                        shouldShowCode.toggle()
                    }
                    delay(0.35){
                        tween($props, from:[\.y : 500, \.alpha: 0], to: [\.y : 0, \.alpha: 1 ])
                    }
                } label: {
                    Image.resizableIcon( shouldShowCode ? .code : .photoFilm, size: 24)
                }

            }
        }
    }
    
    func sandbox(){
    }
}

class Balls: ObservableObject{
    @Published var balls = (0..<100).map{_ in Ball(size: .random(in: 40...70), position: CGPoint.random(in: CGRect(-UIScreen.main.bounds.width/2, -UIScreen.main.bounds.height/2, UIScreen.main.bounds.width, 500 ) ), v: CGPoint.random(in: CGRect(-2, -2, 4, 4) ), bounds: bounds) }
    @Published var updatedCount = 0
}

class Ball: ObservableObject, Hashable, Identifiable{
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    lazy var g: CGFloat =  {
//        (70 - size) / 100 + 0.15
        0.4
    }()
    let damp: CGFloat = 0.9
    let size: CGFloat
    @Published var position:CGPoint
    @Published var rotation:Double = 0
    var color: Color = .random.opacity(0.8)
    var v: CGPoint
    let bounds: CGRect
    init(size: CGFloat, position: CGPoint, v: CGPoint, bounds: CGRect) {
        self.size = size
        self.position = position
        self.v = v
        self.bounds = bounds
    }
    
    var isStill:Bool = true
    
    func update(){
        v += CGPoint(0, g)
        position += v
        
        if position.x - size/2 < bounds.minX {
            position = CGPoint(bounds.minX + size/2 , position.y)
            v = CGPoint(-v.x * damp, v.y)
        }
        if position.x + size/2 > bounds.maxX {
            position = CGPoint(bounds.maxX - size/2, position.y)
            v = CGPoint(-v.x * damp, v.y)
        }
        // upper bound
        if position.y - size/2 < bounds.minY - 400{
            position = CGPoint(position.x, bounds.minY - 400 + size/2)
            v = CGPoint(v.x, -v.y * damp)
        }
        if position.y + size/2 > bounds.maxY {
            position = CGPoint(position.x, bounds.maxY - size/2)
            v = CGPoint(v.x * damp, -v.y * damp)
        }
        rotation += v.x
        if(position.y + size/2 + 50 >= bounds.maxY) {
            isStill = true
        }else{
            isStill = false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
