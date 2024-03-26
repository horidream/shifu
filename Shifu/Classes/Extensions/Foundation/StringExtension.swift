//
//  SwiftExtensions.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/25/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//
import UIKit
import CoreServices
import AVFoundation

private let predicateForUpperCase = NSPredicate.init(format: "SELF MATCHES %@", "^[A-Z]$")

public extension String {

    func test(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        if let reg = try? NSRegularExpression(pattern: pattern, options: options) {
            return reg.firstMatch(in: self, options: [], range: NSRange(0..<self.count)) != nil
        }
        return false
    }

    func replace(pattern: String, with template: String, options: NSRegularExpression.Options = []) -> String {
        if let reg = try? NSRegularExpression(pattern: pattern, options: options) {
            return reg.stringByReplacingMatches(in: self, options: [], range: NSRange(0..<self.count), withTemplate: template)
        }
        return self
    }

    func substring(_ start: Int, _ end: Int = .max) -> String {
        var from = getIndex(start)
        var to = getIndex(end)
        if self.distance(from: from, to: to) >= 0 {
            return String(self[from..<to])
        } else {
            return String(self[to..<from])
        }
    }

    func substr(_ start: Int, _ length: Int = .max) -> String {
        guard length > 0 else { return "" }
        var from = getIndex(start)
        var to = self.index(from, offsetBy: min(length, self.distance(from: from, to: self.endIndex)))
        return String(self[from..<to])
    }

    func findall(pattern: String, options: NSRegularExpression.MatchingOptions = []) -> [[String]] {
        if let regexp = try? NSRegularExpression(pattern: pattern) {
            return regexp.findall(self, options: options)
        } else {
            return [[]]
        }
    }

    private func getIndex(_ offset: Int)->String.Index {
        let maxValue = self.distance(from: self.startIndex, to: self.endIndex)
        if offset >= 0 {
            return self.index(self.startIndex, offsetBy: min(offset, maxValue))
        } else {
            return self.index(self.endIndex, offsetBy: max(offset, -maxValue))
        }
    }

    subscript(n: Int) -> String? {

        let dis = self.distance(from: startIndex, to: endIndex)
        if n > dis || n < -(dis + 1) {
            return nil
        }
        let idx = n >= 0 ? self.index(startIndex, offsetBy: n) : self.index(endIndex, offsetBy: n)
        let idxAdv = index(after: idx)
        let charRange = idx..<idxAdv
        return String(self[charRange])
    }

    subscript(range: Range<Int>) -> String {
        let fromIntValue = range.lowerBound
        let toIntValue = range.upperBound
        let fromIdx = fromIntValue >= 0 ?
        self.index(startIndex, offsetBy: fromIntValue, limitedBy: endIndex) : self.index(endIndex, offsetBy: fromIntValue, limitedBy: startIndex)

        let toIdx = toIntValue >= 0 ? self.index(startIndex, offsetBy: toIntValue, limitedBy: endIndex) : self.index(endIndex, offsetBy: toIntValue, limitedBy: startIndex)
        return String(self[fromIdx!..<toIdx!])
    }

    func trans(with transform: CFString = kCFStringTransformToLatin, reverse: Bool = false) -> String {
        let temp = NSMutableString(string: self)
        CFStringTransform(temp as CFMutableString, nil, transform, reverse)
        return temp as String
    }

    var leadingLetter: String {
        let mutableString = NSMutableString.init(string: self.substring(0, 1) ?? "")
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        let strPinYin = pinyinString.uppercased()
        let firstString = String(strPinYin[..<strPinYin.index(strPinYin.startIndex, offsetBy: 1)])
        return predicateForUpperCase.evaluate(with: firstString) ? firstString : "#"

    }

    func image(_ fontFamily: String = "FontAwesome6Free-Regular", fontSize: CGFloat = 40, fontColor: UIColor = .purple) -> UIImage? {
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

    func canBeRenderedBy(_ fontName: String) -> Bool {
        let uniChars = Array(self.utf16)
        let font = CTFontCreateWithName(fontName as CFString, 0.0, nil)
        var glyphs: [CGGlyph] = [0, 0]
        return CTFontGetGlyphsForCharacters(font, uniChars, &glyphs, uniChars.count)
    }

    func toNotificationName()->Notification.Name {
        return Notification.Name(self)
    }

    func toNotificationPublisher(of object: AnyObject? = nil)->NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: self.toNotificationName(), object: object)
    }

}

public extension String {
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: self, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    var closestDirectoryName: String {
        let comps = URL(fileURLWithPath: self).pathComponents
        return (isDirectory ? comps.get(-1) : comps.get(-2))!
    }
    var file: URL {
        return URL(fileURLWithPath: self)
    }
    
    var fileContent: AnyObject? {
        return self.url?.data?.json()
    }
    
    var url: URL? {

        if self.starts(with: "@") {
            if self.test(pattern: "^@(doc|document|documents)(?=(/|$))") {
                return URL(fileURLWithPath: self.replace(pattern: "^@(doc|document|documents)(?=(/|$))", with: FileManager.path.document))
            } else if self.test(pattern: "^@(temp|tmp)(?=(/|$))") {
                return URL(fileURLWithPath: self.replace(pattern: "^@(temp|tmp)(?=(/|$))", with: FileManager.path.temp))
            } else if self.test(pattern: "^@(cache)(?=(/|$))") {
                return URL(fileURLWithPath: self.replace(pattern: "^@(cache)(?=(/|$))", with: FileManager.path.cache))
            } else {
                var path = self
                path.removeFirst()
                return Bundle.main.url(forResource: path, withExtension: nil) ?? Bundle.main.resourceURL
            }
        } else {
            let arr = self.split(separator: "@")
            if arr.count == 2, let bundleId = arr.get(0)?.string, let path = arr.get(1)?.string {
                return Bundle(identifier: bundleId)?.url(forResource: path, withExtension: nil)
            } else {
                return Bundle.main.url(forResource: arr.get(0)?.string, withExtension: nil) ?? URL(string: self)
                
            }
        }
    }

    @discardableResult func write(to file: String, appending: Bool = false, in directory: URL = env.urls.document) -> Bool {
        return FileManager.default.write(text: self, to: file, appending: appending, in: directory) != nil
    }

    func read(from directory: URL = env.urls.document) -> String? {
        return FileManager.default.read(self, in: directory)
    }
}

public extension String.SubSequence {
    var string: String {
        return String(self)
    }
}

public extension String {
    var normalized: String {
        return self.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\'", with: "\\\'")
    }

    func toMIME() -> Self? {
        return UTTypeCopyPreferredTagWithClass(self as CFString, kUTTagClassMIMEType)?.takeRetainedValue() as String?
    }
    func toUTI() -> Self? {
        let rst =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() as String?
        if rst?.starts(with: "dyn.") == true {
            return nil
        } else {
            return rst
        }
    }

    func UTIToExt() -> Self? {
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
    func parse() -> NSObject? {
        return JSON.parse(self) as? NSObject
    }
    func parse<T: Decodable>(to: T.Type) -> T? {
        T.from(self)
    }
}

public extension String {
    func date(format: String? = nil, timezone: TimeZone = .gmt) -> Date? {
        var autoFormat: String = ""
        switch self.count {
        case 8:
            autoFormat = "yyyyMMdd"
        case 6:
            autoFormat = "yyMMdd"
        case 14:
            autoFormat = "yyyyMMddhhmmss"
        case 10:
            autoFormat = "yyMMddhhmmss"
        default: ()
        }

        let df = DateFormatter()
        df.timeZone = timezone
        df.dateFormat = format ?? autoFormat
        return df.date(from: self)
    }

    func toMetadata(identifier: AVMetadataIdentifier = .iTunesMetadataLyrics) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.value = self as (NSCopying & NSObjectProtocol)?
        item.dataType = kCMMetadataBaseDataType_UTF8 as String
        item.identifier = .iTunesMetadataLyrics
        return item
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

    public func attributedString(font: UIFont, color: UIColor) -> AttributedString {
        return attributedString([.font: font, .foregroundColor: color])
    }

    public func attributedString(_ attributes: [NSAttributedString.Key: Any]? = nil) -> AttributedString {
        let str = NSMutableAttributedString()
        var s: NSAttributedString = NSAttributedString(string: String(self), attributes: attributes)
        return AttributedString(s)
    }
}

public extension String {
    public enum FillPosition {
        case leading, trailing, both
    }

    public func fill(_ str: String, count: Int,        position: String.FillPosition = .leading) -> String {
        let f = String(repeating: str, count: count)
        switch position {
        case .leading:
            return f.substr(0, count - self.count) + self
        case .trailing:
            return self + f.substr( self.count - count )
        case .both:
            let leadingHalf = (count - self.count) / 2
            return f.substr(0, leadingHalf) + self + f.substr(0, count - self.count - leadingHalf )
        }
    }
}

public extension String?{
    var floatValue:Float{
        self?.ns.floatValue ?? 0
    }
}

public extension String{
    var floatValue:Float{
        self.ns.floatValue
    }
}
