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

extension Notification.Name{
    static var hello = "hello".toNotificationName()
}


struct HomeView: View {
    @EnvironmentObject var vm:HomeViewModel
    @ObservedObject private var iO = Self.injectionObserver
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("Examples").font(.headline).padding(10)) {
                    ForEach($vm.featureList){ $f in
                        
                        NavigationLink(isActive: $f.isActive, destination: {
                            f.view
                        }, label: {
                            HStack{
                                Image.icon(f.icon ?? .swift_fa)
                                    .frame(width: 33, height: 33)
                                    .foregroundColor(f.color)
                                    .padding(.trailing, 8)
                                Text(f.name)
                                    .frame(maxWidth: .infinity, alignment: .leading )
                                    .contentShape(Rectangle())
                            }
                        })
                        .onTapGesture {
                            f.isActive = true
                            vm.objectWillChange.send()
                        }
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitle(Text(Shifu.name))
            .onInjection {
//                vm.refresh()
            }
            .onShake {
                sandbox()
                vm.refresh()
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .navigationViewStyle(.stack)
    }
    
    func sandbox(){
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


