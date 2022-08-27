//
//  ModelDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct ModelDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @EnvironmentObject var vm: HomeViewModel
    @State var urlAlpha:Double = 1
    var body: some View {
        VStack{
            HStack(alignment: .firstTextBaseline){
                Text("\(vm.appName)")
                    .font(.title)
                Text("version: \(vm.version)")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .fixedSize(horizontal: true, vertical: true)
            
            Spacer()
                .frame(maxHeight: 20)
            Text("Server: \(vm.serverURL?.absoluteString ?? "N/A")")
                .opacity(urlAlpha)
                .onTapGesture {
                    pb.string = vm.serverURL?.absoluteString
                    ta($urlAlpha).to(0, duration: 0.1).to(1)
                }
            Text("size: \(vm.vw.intValue) x \(vm.vh.intValue)")
                .font(.body)
            Text("language: \(vm.language)")
                .font(.body)
            Text("Device: \(vm.isPhone ? "iPhone" : "iPad" )")
            Text("Reachability: \(vm.isNetworkAvailable ? "true" : "false" )")
        }
//        .onChange(of: vm.serverURL, perform: { newValue in
//            clg(newValue?.absoluteString)
//            injectObserver.injectionNumber += 1
//        })
        .foregroundColor(.purple)
        .padding(32)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.purple, lineWidth: 5)
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        vm.initServer(isLocal: false)
        
    }
}

