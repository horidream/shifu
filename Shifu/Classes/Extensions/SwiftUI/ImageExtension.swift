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
    
    
    static func icon(_ name: Icons.Name, size:CGFloat = 40)->some View{
        if name.isFontAwesome {
            return AnyView(Image(uiImage: Icons.icon(name, size: size))
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit))
        } else {
            return AnyView(Image(systemName: name.value)
                .resizable()
                .renderingMode(.template)
                .font(.system(size: size))
                .aspectRatio(contentMode: .fit))
        }
        
    }
    
    static func faIcon(_ name: FontAwesome.Name, size:CGFloat = 40)->some View{
        return Image(uiImage: FontAwesome.icon(name, size: size))
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
    }
    
    static func sfIcon(_ name: SFSymbols.Name, size:CGFloat = 40)->some View{
        return Image(systemName: name.rawValue)
            .resizable()
            .renderingMode(.template)
            .font(.system(size: size))
            .aspectRatio(contentMode: .fit)
    }
}

