//
//  SwiftToNSExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/8/9.
//

import Foundation


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


public extension Range<Int>{
    var ns: NSRange {
        return NSRange(self)
    }
}

public extension ClosedRange<Int>{
    var ns: NSRange {
        return NSRange(self)
    }
}

extension AttributedString{
    public var ns:NSAttributedString {
        return NSAttributedString(self)
    }
}
