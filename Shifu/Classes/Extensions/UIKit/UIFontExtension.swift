//
//  UIFontExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/5/31.
//

import Foundation
public extension UIFont {
    static func useFontAwesome(){
        if let path = Shifu.bundle.path(forResource: "assets/fa-regular-400", ofType: "ttf") {
            Self.register(path: path )
        }
        if let path = Shifu.bundle.path(forResource: "assets/fa-solid-900", ofType: "ttf") {
            Self.register(path: path )
        }
        if let path = Shifu.bundle.path(forResource: "assets/fa-brands-400", ofType: "ttf") {
            Self.register(path: path )
        }
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

public class FontAwesome{
    static func icon(_ code:String, size:CGFloat, color:UIColor)-> UIImage{
        if code.canBeRenderedBy("FontAwesome6Free-Regular"){
            return code.image("FontAwesome6Free-Regular", fontSize: size, fontColor: color) ?? UIImage()
        }else if code.canBeRenderedBy("FontAwesome6Free-Solid"){
            return code.image("FontAwesome6Free-Solid", fontSize: size, fontColor: color) ?? UIImage()
        }else if code.canBeRenderedBy("FontAwesome6Brands-Regular"){
            return code.image("FontAwesome6Brands-Regular", fontSize: size, fontColor: color) ?? UIImage()
        }
        return UIImage()
    }
    
    public static func icon(_ name: FontAwesome.Name, size: CGFloat = 40, color: UIColor = .red)->UIImage{
        return FontAwesome.icon(name.rawValue, size: size, color: color)
    }
    
}

