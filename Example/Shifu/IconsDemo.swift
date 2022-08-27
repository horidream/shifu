//
//  IconsDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/6/3.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Shifu
import SwiftUI

struct IconsDemo: View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var paused = false
    let layout = [GridItem(.adaptive(minimum: 80))]
    var body: some View{
        ZStack{
            LazyVGrid(columns: layout) {
                ForEach(Icons.Name.allCases.filter{ !$0.isFontAwesome }.shuffled()[...31], id: \.self) { name in
                    Icons.outlineImage(name, size: 60, color: .lightGray, width: 1).sui
                }
                
            }
            .padding()
            TimelineView(.animation(minimumInterval: 0.0167, paused: paused)){ context in
                Image.icon(.swift_fa, size: 200)
                    .foregroundColor(.red)
                    .padding(30)
                    .rotation3DEffect(.degrees( context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 360) * 360 / 5 ), axis: (0, 1, 0))
                
                Image.icon(.swift_sf)
                    .foregroundStyle(.orange, .yellow)
                    .padding(30)
                    .rotation3DEffect(.degrees( context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 360) * 360 / 5 ), axis: (0, 1, 0))
            }
            
        }
        .onTapGesture {
            paused.toggle()
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: .init(colors: [.purple, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
