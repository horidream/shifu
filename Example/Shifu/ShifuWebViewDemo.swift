//
//  ShifuWebViewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Shifu
import SwiftUI
import UIKit

struct ShifuWebViewDemo: View{
    @EnvironmentObject var homeVM: HomeViewModel
    @ObservedObject private var injectionObserver = Self.injectionObserver
    @StateObject var vm = ShifuWebViewModel{
        $0.baseURL = Shifu.bundle.resourceURL?.appendingPathComponent("web")
    }
    
    var body: some View{
        
        VStack{
            ShifuWebView(viewModel:vm)
                .frame(maxHeight: 160)
//            Button("render me", action: updateVue)
//                .padding(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(.green)
//                )
            TextEditor(text: $vm.html.safe(default: ""))
                .padding(8)
                .border(.green)
                .padding()
        }
        .onAppear(perform: updateVue)
        .onInjection {
            updateVue()
        }
        
        
    }
    
    func updateVue(){
        vm.html = #"""
    <style>
    img{
        transform: scale(2);
        transform-origin: 50% 0;
    }
    
    body, #app{
        display: flex;
        flex-direction: column;
        justify-content: start;
        align-items: center;
        font-size: 80px;
    }
    </style>
    <script src="https://unpkg.com/vue@3"></script>
    <div id="app">{{ message }}<img style='border: 1px solid green; border-radius: 10px;' :src='imgSrc'/></div>
    <script>
      Vue.createApp({
        data() {
          return {
            message: 'Hello Vue!!',
            imgSrc: 'icon.png'
          }
        }
      }).mount('#app')
    </script>
    """#
    }
}


