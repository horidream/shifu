//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI


struct Sandbox:View{
  @ObservedObject private var injectObserver = Self.injectionObserver
  var body: some View{
    Text("Birthday: \("19990823".date(timezone: .current)?.toString(locale: .current) ?? "")")
      .foregroundColor(.white)
      .padding(8, 16)
      .background(
        Capsule()
          .fill(Color.blue)
      )
      .onInjection {
        sandbox()
      }
      .onAppear(perform: sandbox)
  }
  
  func sandbox(){
    clg("what!")
    
  }
}
