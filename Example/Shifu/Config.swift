//
//  Config.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Shifu

let clg = Shifu.clg(prefix: ">")

class Test{
    func say()->String{
        "hello"
    }
}

class Theme{
    @ThemedColor(light: .red, dark: .white)
    public static var iconColor
    @ThemedColor(light: .gray, dark: .white)
    public static var titlePrimary
    @ThemedColor(light: .darkGray, dark: .lightGray)
    public static var titleSecondary
}
