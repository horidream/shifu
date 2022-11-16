//
//  UIFontExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/5/31.
//

import Foundation
import SwiftUI

fileprivate var isFontLoaded = false
public extension UIFont {
    
    static func useFontAwesome(){
        guard !isFontLoaded else { return }
        if let path = Shifu.bundle.path(forResource: "assets/fa-regular-400", ofType: "ttf") {
            Self.register(path: path )
        }
        if let path = Shifu.bundle.path(forResource: "assets/fa-solid-900", ofType: "ttf") {
            Self.register(path: path )
        }
        if let path = Shifu.bundle.path(forResource: "assets/fa-brands-400", ofType: "ttf") {
            Self.register(path: path )
        }
        isFontLoaded = true
    }
    
    static func register(path: String) -> Bool {
        guard let fontData = NSData(contentsOfFile: path),    let dataProvider = CGDataProvider.init(data: fontData) else {
            return false
        }
        guard let fontRef = CGFont.init(dataProvider) else {
            return false
        }
        var errorRef: Unmanaged<CFError>? = nil
        guard CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) else   {
            return false
        }
        return true
    }
    
}

