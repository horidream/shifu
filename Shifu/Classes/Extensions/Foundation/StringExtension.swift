//
//  SwiftExtensions.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/25/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//
import  UIKit
import CoreServices

public extension String{
    
    func replace(pattern:String, with template:String, options:NSRegularExpression.Options = [])->String{
        if let reg = try? NSRegularExpression(pattern: pattern, options: options){
            return reg.stringByReplacingMatches(in:self, options:[], range:NSRange(0..<self.count), withTemplate: template)
        }
        return self
    }
    
    
    
    func substring(_ start:Int, _ end:Int = .max)->String{
        var from = getIndex(start)
        var to = getIndex(end)
        if(self.distance(from: from, to: to) >= 0 ){
            return String(self[from..<to])
        }else{
            return String(self[to..<from])
        }
    }
    
    func substr(_ start:Int, _ length:Int = .max)->String{
        guard length > 0 else { return "" }
        var from = getIndex(start)
        var to = self.index(from, offsetBy: min(length, self.distance(from: from, to: self.endIndex)))
        return String(self[from..<to])
    }
    
    func findall(pattern:String, options:NSRegularExpression.MatchingOptions = [])->[[String]]{
        if let regexp = try? NSRegularExpression(pattern: pattern){
            return regexp.findall(self, options: options)
        }else{
            return [[]]
        }
    }
    
    
    private func getIndex(_ offset:Int)->String.Index{
        let maxValue = self.distance(from: self.startIndex, to: self.endIndex)
        if(offset >= 0){
            return self.index(self.startIndex, offsetBy: min(offset, maxValue))
        }else{
            return self.index(self.endIndex, offsetBy: max(offset, -maxValue))
        }
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
    
    
    func image(_ fontFamily:String = "", fontSize:CGFloat = 12, fontColor:UIColor = .black) -> UIImage?{
        let sysFont = UIFont.systemFont(ofSize: fontSize)
        let font = fontFamily == "" ?  sysFont : UIFont(name: fontFamily, size: fontSize) ?? sysFont
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
        return image
    }
    
    func toNotificationName()->Notification.Name{
        return Notification.Name(self)
    }
    
    func toNotificationPublisher(of object:AnyObject? = nil)->NotificationCenter.Publisher{
        return NotificationCenter.default.publisher(for: self.toNotificationName(), object: object)
    }
    
    
}


public extension String{
    var isDirectory:Bool{
        var isDirectory:ObjCBool = false
        FileManager.default.fileExists(atPath: self, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    var closestDirectoryName:String{
        let comps = URL(fileURLWithPath: self).pathComponents
        return (isDirectory ? comps.get(-1) : comps.get(-2))!
    }
    var file:URL{
        return URL(fileURLWithPath: self)
    }
    
    var url:URL?{
        
        if self.starts(with: "@"){
            if self.starts(with: "@documents"){
                return URL(fileURLWithPath: self.replacingOccurrences(of:"@documents", with: FileManager.path.document))
            }else{
                var path = self
                path.removeFirst()
                return Bundle.main.url(forResource: path, withExtension: nil)
            }
        }else{
            let arr = self.split(separator: "@")
            if arr.count == 2, let bundleId = arr.get(0)?.string, let path = arr.get(1)?.string
            {
                return Bundle(identifier: bundleId)?.url(forResource: path, withExtension: nil)
            }
        }
        return URL(string:self)
    }
    
    @discardableResult func write(to file:String, appending:Bool = false, in directory: URL = FileManager.url.document)->Bool{
        return FileManager.default.write(text: self, to: file, appending: appending, in: directory) != nil
    }
    
    func read(from directory: URL = FileManager.url.document)->String?{
        return FileManager.default.read(self, in: directory)
    }
}

public extension String.SubSequence{
    var string: String{
        return String(self)
    }
}

public protocol NSCastable{
    associatedtype NS
    var ns:NS{ get }
}
public extension NSCastable{
    var ns:NS{
        return self as! NS
    }
}

extension String:NSCastable{ public typealias NS = NSString }
extension URL:NSCastable{ public typealias NS = NSURL }

public extension String{
    var normalized:String{
        return self.replacingOccurrences(of: "\\",with: "\\\\")
            .replacingOccurrences(of: "\n",with: "\\n")
            .replacingOccurrences(of: "\r",with: "\\r")
            .replacingOccurrences(of: "\t",with: "\\t")
            .replacingOccurrences(of: "\"",with: "\\\"")
            .replacingOccurrences(of: "\'",with: "\\\'")
    }
    
    func toMIME()->Self?{
        return UTTypeCopyPreferredTagWithClass(self as CFString, kUTTagClassMIMEType)?.takeRetainedValue() as String?
    }
    func toUTI()->Self?{
        let rst =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() as String?
        if (rst?.starts(with: "dyn.") == true){
            return nil
        }else{
            return rst
        }
    }
    
    func UTIToExt()->Self?{
        switch self {
        case "org.openxmlformats.spreadsheetml.sheet":
            return "xlsx"
        case "public.utf8-plain-text", "public.utf16-external-plain-text":
            return "txt"
        default:
            if let ext = UTTypeCopyPreferredTagWithClass(self as CFString, kUTTagClassFilenameExtension)?.takeRetainedValue() {
                return ext as String
            }
            return nil
        }
        
    }
}

public extension String {
    func parse()->NSObject?{
        return JSON.parse(self) as? NSObject
    }
    func parse<T:Decodable>(to: T.Type)->T?{
        T.from(self)
    }
}



public extension String{
    func date(format: String? = nil, timezone:TimeZone = .gmt)->Date?{
        var autoFormat:String = ""
        switch self.count{
        case 8:
            autoFormat = "yyyyMMdd"
        case 6:
            autoFormat = "yyMMdd"
        case 14:
            autoFormat = "yyyyMMddhhmmss"
        case 10:
            autoFormat = "yyMMddhhmmss"
        default:()
        }
        
        let df = DateFormatter()
        df.timeZone = timezone
        df.dateFormat = format ?? autoFormat
        return df.date(from: self)
    }
}


public extension Character {
    var isAscii: Bool {
        return unicodeScalars.first?.isASCII == true
    }
    var ascii: UInt32? {
        return isAscii ? unicodeScalars.first?.value : nil
    }
}

public extension StringProtocol {
    var ascii: [UInt32] {
        return compactMap { $0.ascii }
    }
}
