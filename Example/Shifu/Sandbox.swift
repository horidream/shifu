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
    @State var paused = false
    var body: some View{
        TimelineView(.animation(minimumInterval: 0.0167, paused: paused)){ context in
            Image.faIcon(.swift)
                .foregroundColor(.red)
                .padding(30)
                .rotation3DEffect(.degrees( context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 360) * 360 / 5 ), axis: (0, 1, 0))
            
            Image.sfIcon(.swift)
                .foregroundStyle(.orange, .yellow)
                .padding(30)
                .rotation3DEffect(.degrees( context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 360) * 360 / 5 ), axis: (0, 1, 0))
        }
        .onTapGesture {
            paused.toggle()
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: .init(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
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



