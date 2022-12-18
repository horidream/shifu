//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/2.
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
import VisionKit



struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @Tween var t1
    @Tween var t2
    @Tween var t3
    var body: some View {
        VStack{
            Text("Wake up stuped")
                .foregroundColor(.white)
                .font(.title)
                .tweenProps(t3)
            Text("Yours Passerby=)")
                .foregroundColor(.white)
                .font(.subheadline)
                .tweenProps(t2)
        }
        
        
            .padding()
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(20)
            .padding()
            .onTapGesture {
                tl($t1).from([\.alpha: 0, \.y: 120, \.rotationX: 90, \.blur: 10], duration: 1)
                tl($t2).delay(1.1).from([\.x: 0], to:[\.x: 100], type: .back, duration: 1.5)
                tl($t3).delay(0.9).from([\.x: 0], to:[\.x: -140], type: .back, duration: 1.4)
            }
            .tweenProps(t1)
        .onInjection {
            sandbox()
        }
        .onAppear {
            sandbox()
        }
        
    }
    
    func sandbox() {
        let block = BlockOperation {
            clg("block was called, again")
        }
        let queue = OperationQueue()
        queue.addOperation(block)
    }
    
}

