//
//  Config.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/2/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
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
