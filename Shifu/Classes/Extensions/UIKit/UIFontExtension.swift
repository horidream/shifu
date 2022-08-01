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

public class FontAwesome{
    static func image(_ code:String, size:CGFloat, color:UIColor)-> UIImage{
        
        if let fontName = fontName(for: code){
            return code.image(fontName, fontSize: size, fontColor: color) ?? UIImage()
            
        }
        return UIImage()
    }
    
    public static func fontName(for code:String)->String?{
        UIFont.useFontAwesome()
        return ["FontAwesome6Free-Regular", "FontAwesome6Free-Solid", "FontAwesome6Brands-Regular"].first { name in
            code.canBeRenderedBy(name)
        }
    }
}

public class Icons{
    public static func image(_ name: Icons.Name, size: CGFloat = 40, color: UIColor = .black)->UIImage{
        if name.isFontAwesome {
            return FontAwesome.image(name.value, size: size, color: color)
        } else {
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: size))
            return UIImage(systemName: name.value, withConfiguration: config)?.withTintColor(color) ?? UIImage()
        }
    }
    
    public static func outlineImage(_ name: Icons.Name, size: CGFloat = 40, color: UIColor = .black, width: CGFloat = 1, fill: UIColor = .clear)->UIImage{
        let noFill = fill.hexValue32 == UIColor.clear.hexValue32
        let w =  noFill ?  width : -abs(width)
        if name.isFontAwesome {
            return name.value.attributedString().fontAwesome(size).with(.color(fill), .outline(color, width: w * UIScreen.main.scale)).image()
        } else {
            let c:UIColor = noFill ? .white : fill
            return Self.image(name, size: size, color: c).attributedString().image().stroked(color, width: width)
        }
    }
}

