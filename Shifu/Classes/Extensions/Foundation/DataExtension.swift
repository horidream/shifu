//
//  DataExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

import Foundation
import CryptoKit
import UniformTypeIdentifiers

@available(iOS 13.0, *)
extension Data{
    public var md5: String {
        let computed = Insecure.MD5.hash(data: self)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
    
    public var utf8String:String?{
        return String(data: self, encoding: .utf8)
    }
    
    public func json() -> AnyObject?{
        return JSON.parse(self)
    }
    
    public func parse<T:Decodable>(to: T.Type)->T?{
        if let jsonString = JSON.stringify(json()){
            return T.from(jsonString)
        }
        return nil
    }
}

public extension Data{
    func previewURL(for type:UTType)->URL{
        let fn = "preview-\(self.hashValue)"
        let ext = type.preferredFilenameExtension
        let url = "@temp/\(fn).\(ext ?? "txt")".url!
        if !fm.fileExists(atPath: url.path){
            try? self.write(to: url)
        }
        return url
    }
    
    func previewItem(for type:UTType, title: String? = nil)->PreviewItem{
        return PreviewItem(previewURL(for: type), previewItemTitle: title)
    }
    
}
