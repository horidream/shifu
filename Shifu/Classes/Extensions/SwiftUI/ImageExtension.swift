//
//  ImageExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/1/19.
//

import SwiftUI


public extension Image{
    init?(base64String:String){
        guard let data = Data(base64Encoded: base64String), let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
    
    init(named name: String){
        self = Image(uiImage: UIImage(named: name) ?? UIImage())
    }
    
    init(_ name: Icons.Name, size: CGFloat = 40){
        if name.isFontAwesome {
            self = Image(uiImage: Icons.uiImage(name, size: size)).renderingMode(.template)
        } else {
            self = Image(systemName: name.value)
        }
    }
    
    static func resizableIcon(_ name: Icons.Name, size:CGFloat = 40)->some View{
        var img:Image!
        if name.isFontAwesome {
            img =  Image(uiImage: Icons.uiImage(name, size: size))
        } else {
            img = Image(systemName: name.value)
        }
        return img.resizable()
            .renderingMode(.template)
            .font(.system(size: size))
            .aspectRatio(contentMode: .fit)
    }
}

public extension UIImage {
    var sui:Image{
        return Image(uiImage: self)
    }
}
