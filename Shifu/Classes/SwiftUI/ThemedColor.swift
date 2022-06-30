//
//  ThemedColor.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/6/30.
//

import SwiftUI


@propertyWrapper
public struct ThemedColor
{
    let light: UIColor
    let dark: UIColor

    public init(light: UIColor, dark: UIColor)
    {
        self.light = light
        self.dark = dark
    }

    public var wrappedValue: UIColor
    {
        return UIColor {
            traitCollection -> UIColor in
            let style = Shifu.keyWindow?.traitCollection.userInterfaceStyle ?? traitCollection.userInterfaceStyle
            switch style
            {
            case .dark:
                return dark

            case .light,
                 .unspecified:
                return light

            @unknown default:
                return light
            }
        }
    }
}

