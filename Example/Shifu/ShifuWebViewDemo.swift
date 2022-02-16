//
//  ShifuWebViewDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Shifu
import SwiftUI

struct ShifuWebViewDemo: View{
    @StateObject var vm = ShifuWebViewModel{
        $0.html = #"""
<style>
            body{
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                transform: scale(3);
            }
</style>
<h2>Hello</h2><img src='./icon.png'/>
"""#
        $0.baseURL = Shifu.bundle.resourceURL?.appendingPathComponent("web")
    }
    var body: some View{
        VStack{
            ShifuWebView(viewModel:vm)
            Button("click me") {
                vm.html = #"""
            <style>
            body{
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                transform: scale(6);
            }
            </style>
            <body>
                <script src="https://unpkg.com/vue@3"></script>
                <div id="app">{{ message }}</div>
                <script>
                  Vue.createApp({
                    data() {
                      return {
                        message: 'Hello Vue!'
                      }
                    }
                  }).mount('#app')
                </script>
            </body>
            """#
            }
        }
        
    }
}
