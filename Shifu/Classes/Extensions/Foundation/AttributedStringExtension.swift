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
    
    @discardableResult mutating public func apply(_ containers: AttributeContainer..., mergePolicy: AttributeMergePolicy = .keepNew)->Self{
        containers.forEach { c in
            self.mergeAttributes(c, mergePolicy: mergePolicy)
        }
        return self
    }
    
    public func with(_ containers: AttributeContainer..., mergePolicy: AttributeMergePolicy = .keepNew)->Self{
        var this = self
        containers.forEach { c in
            this.mergeAttributes(c, mergePolicy: mergePolicy)
        }
        return this
    }
    
    public func fontAwesome(_ size: CGFloat = 40)->Self{
        var this = self
        if let name = FontAwesome.fontName(for: self.ns.string){
            this.mergeAttributes(AttributeContainer([.font : UIFont(name: name, size: size)]))
        }else {
            this.mergeAttributes(AttributeContainer([.font : UIFont.systemFont(ofSize: size)]))
        }
        return this
    }
    
    
    public func image() -> UIImage{
        let _ns = self.ns
        let size = _ns.size()
        let strokeWidth = abs(_ns.attributes(at: 0, effectiveRange: nil)[.strokeWidth] as? CGFloat ?? 0)
        UIGraphicsBeginImageContextWithOptions(size.extends(strokeWidth, strokeWidth), false, 0)
        let rect = CGRect(origin: .init(strokeWidth/2, strokeWidth/2), size: size)
        
        _ns.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

extension AttributeContainer{
    public static func color(_ color: UIColor)->Self{
        return .init([.foregroundColor: color])
    }
    
    public static func outline(_ color: UIColor = .white, width: CGFloat = -1)->Self{
        return .init([.strokeColor: color, .strokeWidth: width])
    }
    
}
