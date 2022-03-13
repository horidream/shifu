//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct Sandbox:View{
  @ObservedObject private var injectObserver = Self.injectionObserver
  var body: some View{
    let strings = [
      "100823".date(timezone: .gmt + 8)?.toString() ?? "",
      "19990823121149".date(timezone: .current)?.toString() ?? "",
      Date().toString(formatter: .formatter(with:"yyyyMMMMddhhmmss", timeZone: .current - 15, locale: .ja_JP)) ?? ""
    ]
    Group{
      ForEach(strings, id: \.self) { content in
        Text(content)
          .onTapGesture {
            Announcer.say(content, locale: .ja_JP)
          }
      }
    }
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
    
    clg("hot reloading!")
    
  }
}
