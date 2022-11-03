//
//  JSON.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/5.
//

import Foundation
import JavaScriptCore

public class JSON{
    public static func stringify(_ obj:Any?) -> String?{
        if let obj = obj as? Encodable{
            if let data = try? JSONEncoder().encode(obj){
                return String(data: data, encoding: .utf8)
            }
        }
        if JSONSerialization.isValidJSONObject(obj),
            let obj = obj,
            let data = try? JSONSerialization.data(withJSONObject: obj, options: []){
            return (String(bytes: data, encoding: .utf8))
        }
        return nil
        
    }
    
    public static func parse(_ data:Data?) -> AnyObject?{
        if let data = data{
            do{
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
            }catch{
                return nil
            }
        }
        return nil
    }
    
    public static func parse(_ str:String?) -> AnyObject?{
        let data = str?.data(using:.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            
            do{
                // Will return an object or nil if JSON decoding fails
                return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject
            }catch{
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

public extension Dictionary where Key == String{
    func stringify()->String?{
        return JSON.stringify(self)
    }
    
    func value(for key:String)->Any?{
        return (self as NSDictionary).value(forKey:key)
    }
}

public extension NSObject{
    func stringify()->String?{
        return JSON.stringify(self)
    }
}


public extension Encodable{
    func stringify(withSortedKey: Bool = false)->String?{
        let encoder = JSONEncoder()
        if withSortedKey {
            encoder.outputFormatting = .sortedKeys
        }
        if let data = try? encoder.encode(self){
            return data.utf8String
        }
        return nil
    }
}

public extension Decodable{
    static func from(_ string:String)->Self?{
        if let data = string.data(using: .utf8){
            return try? JSONDecoder().decode(Self.self, from: data)
        }
        return string as? Self
    }
}



public protocol JsonMergeable: Codable{
    func merge(_ other: Self)->Self
}

let js = JSContext()
public extension JsonMergeable {
    
    func merge(_ other: Self)->Self{
        let a = self.stringify() ?? "{}"
        let b = other.stringify() ?? "{}"
        let cmd = "JSON.stringify(Object.assign(JSON.parse('\(a)'), JSON.parse('\(b)')))"
        let rst = js?.evaluateScript(cmd)
        if let json = rst?.toString(){
            return json.parse(to: Self.self) ?? self
        }
        return self
    }
    
    func merge(_ other: [String: Codable])->Self{
        let a = self.stringify() ?? "{}"
        let b = other.stringify() ?? "{}"
        let cmd = "JSON.stringify(Object.assign(JSON.parse('\(a)'), JSON.parse('\(b)')))"
        let rst = js?.evaluateScript(cmd)
        if let json = rst?.toString(){
            return json.parse(to: Self.self) ?? self
        }
        return self
    }
    
    func mergeToRawObject(_ other: [String: Codable])->NSDictionary{
        let a = self.stringify() ?? "{}"
        let b = other.stringify() ?? "{}"
        let cmd = "Object.assign(JSON.parse('\(a)'), JSON.parse('\(b)'))"
        let rst = js?.evaluateScript(cmd).toObject() as? NSDictionary
        return rst ?? NSDictionary()
    }
}


extension Dictionary: JsonMergeable where Key==String, Value:Codable {}

@propertyWrapper
public struct CodableColor {
    public init(wrappedValue: UIColor){
        self.wrappedValue = wrappedValue
    }
    public var wrappedValue: UIColor
}

extension CodableColor: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
