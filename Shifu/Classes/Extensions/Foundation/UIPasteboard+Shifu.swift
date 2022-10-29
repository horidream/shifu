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
    func setPreviewItem(_ item: PreviewItem?){
        if let data = item?.data {
            setData(data, forPasteboardType: item?.typeIdentifier ?? UTType.data.identifier)
        } else {
            items = []
        }
    }
    
    func previewURL(for types: [UTType]) -> (URL?, UTType)? {
        let typesInPasteboard = self.types
        var url: URL? = nil
        for type in types{
            if let t = typesInPasteboard.first{ UTType($0)?.conforms(to: type) ?? false } , let ut = UTType(t),  let data = self.data(forPasteboardType: t){
                url = data.previewURL(for: ut)
                return (url, ut)
            }
        }
        
        return nil
    }
    
    func previewItem(for types: [UTType]) -> PreviewItem?{
        if let (url, type) = previewURL(for: types){
            return PreviewItem(url, typeIdentifier: type.identifier)
        }
        return nil
    }
}

