//
//  AttributedStringDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/7/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit
import ShifuLottie





struct AttributedStringDemo:View{
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = [].attributedString()
    @StateObject var colorManager = ColorSchemeMananger()
    @StateObject var prop = TweenProps()
    @StateObject var props = ObservableArray((1...10).map{_ in TweenProps() })
    var body: some View {
        VStack {
            ThemePicker()
            UIText(text)
                .onTapTarget { _ in
                    tween(props.wrapper(at: 2), from: [
                        \.scale: 0.3
                    ], to: [
                        \.scale: 1
                    ], type: .back)
                    pb.image = snapshot( backgroundColor: .white)
                }
            Image.resizableIcon(.tree, size: 100)
                .foregroundColor(.green)
                .tweenProps(prop)
                .onTapTarget { _ in
                    tween($prop, from: [
                        \.rotationY: 429,
                         \.scale: 0.2,
                         \.blur: 10
                         
                    ], to: [
                        \.x : 0
                    ], duration: 1,  type: .back)
                }
            
            
            
            Spacer()
            SimpleMarkdownViewer(content: #"""
            **This demo is showing how to compose rich text**
            ```swift
            text = ["Hi", "Swift", "\nMay the force \nbe with you"]
                .attributedString([
                    .font: UIFont.boldSystemFont(ofSize: 28),
                    .foregroundColor: UIColor.lightGray,
                    .paragraphStyle: with(NSMutableParagraphStyle()){ $0.alignment = .center }
                    ], attributes:[
                        [.foregroundColor: Theme.titlePrimary, .font: UIFont.boldSystemFont(ofSize: 96), .strokeColor: Theme.titleSecondary, .strokeWidth: NSNumber(-2)]
                ])
            text.replace("Swift", with: Icons.image(.swift_fa, color: .red).attributedString([.baselineOffset: -3]))
            ```
            """#, css: "pre{ margin-top: 5px; } p{ text-align: center; padding-top: 10px; }")
            .id(injectObserver.injectionCount)
        }
        .tweenProps(props.value(at: 0))
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: colorManager.colorScheme) { _ in
            tween(props.wrapper(at: 0), to: [
                \.alpha: 0,
                 \.blur: 10,
                 \.scale: 0.8
                 
            ], duration: 0.3,  type: .easeOut)
            delay(0.3){
                sandbox()
                tween(props.wrapper(at: 0), from: [
                    \.rotationY: 99,
                     \.scale: 0.2,
                     \.alpha: 0.3,
                     \.blur: 10
                     
                ], to: [
                    \.rotationY : 0,
                     \.scale: 1,
                     \.alpha: 1,
                     \.blur: 0
                ], duration: 1,  type: .back)
                
                tween($prop, from: [
                    \.rotationY : 300,
                     \.alpha: 0,
                     \.scale: 0.1,
                     \.blur: 10
                     
                     
                ], to: [
                    \.x : 0
                ], duration: 1 , delay: 0.5,  type: .back)
            }
        }
        .tweenProps(props.value(at: 2))
        
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        text = ["Hi", "Swift", "\nMay the force \nbe with you"].attributedString([.font: UIFont.boldSystemFont(ofSize: 28), .foregroundColor: UIColor.lightGray, .paragraphStyle: with(NSMutableParagraphStyle()){ $0.alignment = .center }], attributes:[
            [.foregroundColor: Theme.titlePrimary, .font: UIFont.boldSystemFont(ofSize: 96), .strokeColor: Theme.titleSecondary, .strokeWidth: NSNumber(-2)],
            nil
        ])
        text.replace("Swift", with: Icons.uiImage(.swift_fa, color: Theme.iconColor).attributedString([.baselineOffset: -3]))
    }
    
}


