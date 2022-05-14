//
//  ShimmerDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/5/9.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct ShimmerDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View {
        VStack(spacing: 25){
            Text("iPhone 5")
                .font(.system(size: 75, weight: .bold))
                .modifier(Shimmer())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        clg("OK")
    }
}

