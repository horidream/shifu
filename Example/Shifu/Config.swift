//
//  Config.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI
import Shifu

private let _clg = Shifu.clg(prefix: " ")
func clg(file: String = #file, line: Int = #line,  _ args: Any?...){
    if let fn = file.url?.filename{
        _clg(args.compactMap{ $0 ?? "nil" } + ["(\(fn):\(line))"])
    }
}

let localized = Shifu.localizer()

class Test: NSObject{
    func say()->String{
        "hello"
    }
}

struct Person: Codable{
    let name:String
    let age:Int
}

class Theme{
    @ThemedColor(light: .red, dark: .white)
    public static var iconColor
    @ThemedColor(light: .gray, dark: .white)
    public static var titlePrimary
    @ThemedColor(light: .darkGray, dark: .lightGray)
    public static var titleSecondary
    
    @ThemedColor(light: .white, dark: .black)
    public static var background
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
