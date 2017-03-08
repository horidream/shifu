//
//  SwiftExtensions.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/25/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

public extension String{
    
    public func replace(pattern:String, with template:String, options:NSRegularExpression.Options = [])->String{
        if let reg = try? NSRegularExpression(pattern: pattern, options: options){
            return reg.stringByReplacingMatches(in:self, options:[], range:NSRange(0..<self.characters.count), withTemplate: template)
        }
        return self
    }
    
    public func substring(with range:Range<Int>)->String{
        let r = Range<String.Index>(self.index(self.startIndex, offsetBy: range.lowerBound) ..< self.index(self.startIndex, offsetBy: range.upperBound))
        return self.substring(with: r)
    }
    
    public subscript(n: Int)->String?{
        
        let dis = self.distance(from:startIndex, to: endIndex)
        if(n > dis || n < -(dis + 1)){
            return nil
        }
        let idx = n >= 0 ? self.index(startIndex, offsetBy: n) : self.index(endIndex, offsetBy: n)
        let idxAdv = index(after: idx)
        let charRange = idx..<idxAdv
        return self.substring(with: charRange)
    }
    
    
    public subscript(range:Range<Int>)->String{
        let fromIntValue = range.lowerBound
        let toIntValue = range.upperBound
        let fromIdx = fromIntValue >= 0 ?
            self.index(startIndex, offsetBy: fromIntValue, limitedBy: endIndex) : self.index(endIndex, offsetBy: fromIntValue, limitedBy: startIndex)
        
        let toIdx = toIntValue >= 0 ? self.index(startIndex, offsetBy: toIntValue, limitedBy: endIndex) : self.index(endIndex, offsetBy: toIntValue, limitedBy: startIndex)
        return self.substring(with: fromIdx!..<toIdx!)
    }
    
    public func trans(with transform:CFString = kCFStringTransformToLatin, reverse:Bool = false)->String{
        let temp = NSMutableString(string:self)
        CFStringTransform(temp as CFMutableString, nil, transform, reverse)
        return temp as String
    }
    
    public var leadingLetter:String{
        let mutableString = NSMutableString.init(string: self)
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        let strPinYin = pinyinString.uppercased()
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy:1))
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"

    }
}
