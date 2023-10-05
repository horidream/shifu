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
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var tunnel: PeerToPeerTunnel = PeerToPeerTunnel()
    @StateObject var colorManager = ColorSchemeMananger.shared
    @State private var selectedFeature: FeatureViewModel<AnyView>? = nil
    @ObservedObject private var iO = Self.injectionObserver
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedFeature) {
                Section(header: Text("Examples").font(.headline).padding(10)) {
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
                }
            }
            .listStyle(.plain)
            .if(vm.isPhone){
                $0.navigationBarTitle(Text(Shifu.name))
            }
        } detail: {
            selectedFeature?.view
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
            sandbox()
            vm.refresh()
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
        .onAppear(){
            colorManager.applyColorScheme()
            DispatchQueue.main.async{
                selectedFeature = vm.featureList.first { $0.isActive }
            }
            
        }
        .environmentObject(tunnel)
        .navigationViewStyle(.stack)
    }
    
    func sandbox() {
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
