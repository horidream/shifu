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
    public typealias ColorScheme = UIUserInterfaceStyle
    @AppStorage("colorScheme") public var colorScheme: UIUserInterfaceStyle = .unspecified{
        didSet{
            applyColorScheme()
        }
    }
    
    public init(){}
    
    public func applyColorScheme(){
        Shifu.keyWindow?.overrideUserInterfaceStyle = colorScheme
    }
}
