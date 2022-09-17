//
//  ThemedColor.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/6/30.
//

import SwiftUI


@available(iOSApplicationExtension, unavailable)
@propertyWrapper
public struct ThemedColor
{
    let light: ()->UIColor
    let dark: ()->UIColor

    public init(light: @autoclosure @escaping ()->UIColor, dark: @autoclosure @escaping ()->UIColor)
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
                return dark()

            case .light,
                 .unspecified:
                return light()

            @unknown default:
                return light()
            }
        }
    }
}

