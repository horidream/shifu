//
//  re.swift
//  Shifu
//
//  Created by Baoli Zhai on 9/18/16.
//  Copyright © 2016 Baoli Zhai. All rights reserved.
//

import Foundation

public extension NSRegularExpression{
    
    func findall(_ string:String, options:NSRegularExpression.MatchingOptions = [])->[[String]]{
        let matches = self.matches(in: string, options: options, range:NSMakeRange(0, string.utf16.count))
        var result:[[String]] = []
        for m in matches as [NSTextCheckingResult]{
            var sub:[String] = []
            for g in 0..<m.numberOfRanges{
                let subrange = m.range(at: g)
                if(subrange.location != NSNotFound){
                    let substring = (string as NSString).substring(with: subrange)
                    sub.append(substring)
                }
            }
            result.append(sub)
        }
        return result
    }
    
    func test(_ testString: String)->Bool{
        let range = NSRange(testString.startIndex..., in: testString)
        return  self.firstMatch(in: testString, range: range) != nil
    }
}

extension Collection where Iterator.Element == [String]{
    public func group(_ index:Int)->[String]{
        let arr = self as! Array<[String]>
        return arr[index]
    }
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension BidirectionalCollection where Self.SubSequence == Substring {
    public func match<R>(_ regex: R) -> Regex<R.RegexOutput>.Match? where R : RegexComponent{
        return wholeMatch(of: regex)
    }
    
    public func findall<R>(_ regex: R) -> [R.RegexOutput] where R : RegexComponent{
        matches(of: regex).map{ $0.0 }
    }
}

