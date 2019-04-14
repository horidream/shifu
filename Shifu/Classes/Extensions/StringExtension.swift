//
//  SwiftExtensions.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/25/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

public extension String{
    
    func replace(pattern:String, with template:String, options:NSRegularExpression.Options = [])->String{
        if let reg = try? NSRegularExpression(pattern: pattern, options: options){
            return reg.stringByReplacingMatches(in:self, options:[], range:NSRange(0..<self.count), withTemplate: template)
        }
        return self
    }
    
    func substring(with range:Range<Int>)->String{
        let r = self.index(self.startIndex, offsetBy: range.lowerBound) ..< self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[r])
    }
    
    subscript(n: Int)->String?{
        
        let dis = self.distance(from:startIndex, to: endIndex)
        if(n > dis || n < -(dis + 1)){
            return nil
        }
        let idx = n >= 0 ? self.index(startIndex, offsetBy: n) : self.index(endIndex, offsetBy: n)
        let idxAdv = index(after: idx)
        let charRange = idx..<idxAdv
        return String(self[charRange])
    }
    
    
    subscript(range:Range<Int>)->String{
        let fromIntValue = range.lowerBound
        let toIntValue = range.upperBound
        let fromIdx = fromIntValue >= 0 ?
            self.index(startIndex, offsetBy: fromIntValue, limitedBy: endIndex) : self.index(endIndex, offsetBy: fromIntValue, limitedBy: startIndex)
        
        let toIdx = toIntValue >= 0 ? self.index(startIndex, offsetBy: toIntValue, limitedBy: endIndex) : self.index(endIndex, offsetBy: toIntValue, limitedBy: startIndex)
        return String(self[fromIdx!..<toIdx!])
    }
    
    func trans(with transform:CFString = kCFStringTransformToLatin, reverse:Bool = false)->String{
        let temp = NSMutableString(string:self)
        CFStringTransform(temp as CFMutableString, nil, transform, reverse)
        return temp as String
    }
    
    var leadingLetter:String{
        let mutableString = NSMutableString.init(string: self)
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        let strPinYin = pinyinString.uppercased()
        let firstString = String(strPinYin[..<strPinYin.index(strPinYin.startIndex, offsetBy:1)])
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
        
    }
    
    
    func image(_ fontFamily:String, fontSize:CGFloat, fontColor:UIColor = .blue) -> UIImage{
        let font = UIFont(name: fontFamily, size: fontSize)!
        let style = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = .left
        let attr = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: fontColor,
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        let size = self.size(withAttributes: attr)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(origin: .zero, size: size)
        self.draw(in: rect, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
