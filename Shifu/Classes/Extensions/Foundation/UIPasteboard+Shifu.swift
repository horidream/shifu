//
//  UIPasteboard+Shifu.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/26.
//

import Foundation
import UniformTypeIdentifiers

public extension UIPasteboard{
    var html:String? {
        if let data = self.data(forPasteboardType: "public.html"), let html = data.utf8String
        {
            return html
        }
        return nil
    }
    
    var rawHTML: String?{
        if let html = html {
            return Shifu.escape(html)
        }
        return nil
    }
}

public extension UIPasteboard {
    func previewURL(for types: [UTType]) -> URL? {
        let typesInPasteboard = self.types
        var url: URL? = nil
        for type in types{
            let identifier = type.identifier
            if typesInPasteboard.contains(identifier), let data = self.data(forPasteboardType: identifier){
                url = data.previewURL(for: type)
                break
            }
        }
        
        return url
    }
    
    func previewItem(for types: [UTType]) -> PreviewItem?{
        let url = previewURL(for: types)
        if types.count > 0 {
            return PreviewItem(url)
        } else {
            return nil
        }
    }
}

