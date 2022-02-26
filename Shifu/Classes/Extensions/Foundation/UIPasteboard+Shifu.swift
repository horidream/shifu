//
//  UIPasteboard+Shifu.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/26.
//

import Foundation

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
