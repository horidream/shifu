//
//  DataExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

import Foundation
import CryptoKit

@available(iOS 13.0, *)
extension Data{
    public var md5: String {
        let computed = Insecure.MD5.hash(data: self)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
    
    public var utf8String:String?{
        return String(data: self, encoding: .utf8)
    }
    
    public func parseJSON() -> AnyObject{
        return JSON.parse(self)
    }
}
