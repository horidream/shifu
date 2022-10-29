//
//  String+HTML.swift
//  ShifuWebServer
//
//  Created by Baoli Zhai on 2022/10/28.
//

import Foundation
import SwiftSoup

public extension String {
    var textExtractedFromHTML:String {
        if isHTMLLikeString {
            do {
                let html = self
                let doc: Document = try SwiftSoup.parse(html)
                return  (try? doc.text()) ?? ""
            } catch {
                return ""
            }
        } else {
            return self
        }
    }
    
    var isHTMLLikeString:Bool{
        self.trimmingCharacters(in: .whitespaces).test(pattern: "^<.*>$", options: [.dotMatchesLineSeparators])
    }
}
