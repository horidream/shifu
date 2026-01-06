//
//  HomeView.swift
//  Shifu_Example
//
//  Created by Baoli Zhai on 2021/4/6.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import Combine
import Shifu

extension Notification.Name {
    static var hello = "hello".toNotificationName()
}

struct HomeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var tunnel: PeerToPeerTunnel = PeerToPeerTunnel()
    @StateObject var colorManager = ColorSchemeMananger.shared
    @State private var selectedFeature: FeatureViewModel<AnyView>? = nil
    @ObservedObject private var iO = Self.injectionObserver
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selectedFeature) {
//                Section(header: Text("Examples").font(.headline).padding(10)) {
                    ForEach(Array(zip(vm.featureList.indices, vm.featureList)), id: \.0) { idx, f in
                        NavigationLink(value: f) {
                            HStack {
                                Image.resizableIcon(f.icon ?? .swift_fa)
                                    .padding(5)
                                    .frame(width: 33, height: 33)
                                    .foregroundColor(f.color)
                                    .padding(0, 8)
                                Text("\(String(idx).fill("0", count: 2)) - \(f.name)")
                                    .font(.system(.subheadline, design: .monospaced))
                                    .frame(maxWidth: .infinity, alignment: .leading )
                                    .contentShape(Rectangle())
                            }
                        }
                    }
//                }
            }
            .listStyle(.plain)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitle(Text(Shifu.name))
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            selectedFeature?.view
                .environment(\.dismissDetail) {
                    selectedFeature = nil
                }
        }
        .background{
            SimpleMarkdownViewer(content: "## Hello")
                .frame(width:100, height: 100)
                .offset(y:3000)
        }
        .onInjection {
            //                vm.refresh()
        }
        .onShake {
            selectedFeature = nil
        }
        
        .onAppear(){
//            Shifu.config.shouldPrintWebLog = true;
            colorManager.applyColorScheme()
//            DispatchQueue.main.async{
//                selectedFeature = vm.featureList.first { $0.isActive }
//            }
            
        }
        .environmentObject(tunnel)
        //            .ignoresSafeArea(.all, edges: .bottom)
        .navigationViewStyle(.stack)
    }
    
    func sandbox() {
    }
}


