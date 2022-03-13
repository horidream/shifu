//
//  DateExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/13.
//

import Foundation

public extension TimeZone{
    static var gmt:TimeZone = TimeZone(secondsFromGMT: 0)!
}

public extension Locale{
    static var zh_CN:Locale = Locale(identifier: "zh_CN")
}

public extension DateFormatter{
    static func formatter(with format:String)->DateFormatter{
        let df = DateFormatter()
        df.timeZone = .gmt
        df.dateFormat = format
        df.setLocalizedDateFormatFromTemplate(format)
        return df
    }
    static var day:DateFormatter = formatter(with: "yyyyMMdd")
    static var dayAndTime:DateFormatter = formatter(with: "yyyyMMddhhmmss")
}

public extension Date{
    func toString(locale: Locale = .current, formatter:DateFormatter = .day)->String?{
        var f = formatter
        f.locale = locale
        f.setLocalizedDateFormatFromTemplate(formatter.dateFormat)
        return f.string(from: self)
    }
}
