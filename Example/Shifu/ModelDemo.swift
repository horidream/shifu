//
//  ModelDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

struct ModelDemo: View {
  @ObservedObject private var injectObserver = Self.injectionObserver
  @EnvironmentObject var vm: HomeViewModel
  var body: some View {
    VStack{
      
      HStack(alignment: .center){
        Text("\(vm.appName)")
          .font(.title)
        Text("version: \(vm.version)")
          .font(.subheadline)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .fixedSize(horizontal: true, vertical: true)
      Spacer()
        .frame(maxHeight: 66)
      Text("size: \(vm.vw.intValue) x \(vm.vh.intValue)")
        .font(.body)
      Text("language: \(vm.language)")
        .font(.body)
      Text("Device: \(vm.isPhone ? "iPhone" : "iPad" )")
      Text("Reachability: \(vm.isNetworkAvailable ? "true" : "false" )")
    }
    .onInjection {
      
    }
  }
}

