//
//  ColorThemeManager.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/13.
//

import SwiftUI
import UIKit



@available(iOS 14.0, *)
public class ColorSchemeMananger: ObservableObject{
    public static let shared = ColorSchemeMananger()
    public typealias ColorScheme = UIUserInterfaceStyle
    @available(iOSApplicationExtension, unavailable)
    @AppStorage("colorScheme") public var colorScheme: UIUserInterfaceStyle = .unspecified{
        didSet{
            applyColorScheme()
        }
    }
    
    public init(){}
    
    @available(iOSApplicationExtension, unavailable)
    public func applyColorScheme(){
        Shifu.keyWindow?.overrideUserInterfaceStyle = colorScheme
    }
}
