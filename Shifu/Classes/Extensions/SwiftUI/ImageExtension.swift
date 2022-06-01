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
    
    static func faIcon(_ name: FontAwesome.Name)->some View{
        return Image(uiImage: FontAwesome.icon(name, size: UIScreen.main.bounds.size.width))
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
    }
    
    static func sfIcon(_ name: SFSymbols.Name)->some View{
        return Image(systemName: name.rawValue)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
    }
}

