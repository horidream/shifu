//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import UniformTypeIdentifiers
import CoreServices

struct Sandbox: View {
    @ObservedObject private var injectObserver = Self.injectionObserver

    var body: some View {
        VStack{
            Text("Hello")
                
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        clg(UTType.excel)
        clg(UTType.docx)
//        _rootViewController.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
    }
}


 
