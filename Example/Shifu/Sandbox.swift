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
    @StateObject var d1 = Digit()
    @StateObject var d2 = Digit()
    @Tween var t
    var d2Number: Int {
        return injectObserver.injectionCount + d1.number * 3
    }
    var body: some View {
            HStack{
                d1.view
                Text("x")
                d2.view
                Text(" = ")
                Text("\(d1.number * d2.number)")
            }
            .font(.system(size: 30))
            .frame(width: 300)
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.green)
            )
            .tweenProps(t)
            
        .onTapGesture {
            tl($t).to([\.y: -100, \.alpha: 0]).perform {
                d1.number = Int.random(in: 1...100)
                d2.number = d2Number
            }
            .delay(0.2)
            .from([\.y: 100, \.alpha: 0], to: [\.y: 0, \.alpha: 1])
        }
        .onInjection {
            sandbox()
        }
        .onAppear {
            sandbox()
        }
        
    }
    
    func sandbox() {
        
    }
    
}



class Digit: ObservableObject{
    @Published var number = 0
    
    var view: some View {
        Text(String(number))
            .foregroundColor(.random)
    }
}
