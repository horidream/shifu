//
//  DateExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/3/13.
//

import Foundation

public func +(left: TimeZone, right: Int)->TimeZone{
    return left.offset(right)
}
public func -(left: TimeZone, right: Int)->TimeZone{
    return left.offset(-right)
}

public extension TimeZone{
    static var gmt:TimeZone = TimeZone(secondsFromGMT: 0)!
    func offset(_ right:Int) -> TimeZone{
        let offset = self.secondsFromGMT() / 3600
        return TimeZone(secondsFromGMT: (offset + right ) % 12 * 3600) ?? .gmt
    }
}

public extension Locale{
    static var zh_CN:Locale = Locale(identifier: "zh_CN")
    static var ja_JP:Locale = Locale(identifier: "ja_JP")
}

public extension DateFormatter{
    static func formatter(with format:String = "yyyyMMMMdd" , timeZone: TimeZone = .current, locale:Locale = Shifu.locale)->DateFormatter{
        let df = DateFormatter()
        df.timeZone = timeZone
        df.locale = locale
        df.dateFormat = format
        df.setLocalizedDateFormatFromTemplate(format)
        return df
    }
    static var day:DateFormatter = formatter(with: "yyyyMMMMdd")
    static var dayAndTime:DateFormatter = formatter(with: "yyyyMMMMddhhmmss")
}

public extension Date{
    func toString(formatter: DateFormatter = .dayAndTime)->String?{
        return formatter.string(from: self)
    }
    
    func component(_ component: Calendar.Component) -> Int{
        Calendar.current.component(component, from: self)
    }
}
