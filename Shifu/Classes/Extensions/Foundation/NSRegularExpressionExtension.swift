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
}

extension Collection where Iterator.Element == [String]{
    public func group(_ index:Int)->[String]{
        let arr = self as! Array<[String]>
        return arr[index]
    }
}

@available(iOS 16.0, *)
public extension Regex{
    func findall(_ string: String)->Regex<Output>.Match?{
        try? self.firstMatch(in: string)
    }
}
