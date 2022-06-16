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
        Group{
            if #available(iOS 16.0, *) {
                NavigationStack{
                    NavigationLink(value: "OK"){
                        Label {
                            Text("YouTube")
                                .bold()
                        } icon: {
                            Image(.youtube)
                                .foregroundColor(.red)
                        }
                        .frame(height: 50)
                    }
                    
                    .navigationDestination(for: String.self) { value in
                        Text(value)
                    }
                }
                
            } else {
                Text("Not Implemented")
            }
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

