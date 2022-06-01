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
    var body: some View{
        TimelineView(.animation){ context in
            Image.faIcon(.paypal)
                .foregroundColor(.red)
                .padding(30)
                .rotation3DEffect(.degrees( context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 360) * 360 / 5 ), axis: (1, 0, 0))
            
            Image.sfIcon(.pianokeys)
                .foregroundStyle(.orange, .yellow)
                .padding(30)
                .rotation3DEffect(.degrees( -context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 360) * 360 / 5 ), axis: (1, 0, 0))
        }
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



