//
//  AttributedStringExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/7/2.
//

import Foundation


extension Array where Element == String{
    public func attributedString(_ common: [NSAttributedString.Key : Any]? = nil, attributes: [[NSAttributedString.Key : Any]?] = [])->AttributedString{
        let str = NSMutableAttributedString()
        var s:NSAttributedString

        
        for (index, sub) in self.enumerated() {
            if let attrOption = attributes.get(index), let attr = attrOption{
                s = NSAttributedString(string: sub, attributes: attr.merging(common ?? [:]) { (current, _) in current })
            } else {
                s = NSAttributedString(string: sub, attributes: common)
            }
            str.append(s)
        }
        return AttributedString(str)
    }
}

extension NSAttributedString{
    public var nt:AttributedString{
        return AttributedString(self)
    }
}
extension AttributedString{
    public var ns:NSAttributedString {
        return NSAttributedString(self)
    }
    
    mutating public func replace(_ string: String, with other: AttributedString?){
        guard let other = other else { return }
        while let range = range(of: string){
            self.replaceSubrange(range, with: other)
        }
    }
}
