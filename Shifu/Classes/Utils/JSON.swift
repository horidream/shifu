//
//  JSON.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/5.
//

import Foundation

public class JSON{
    public static func stringify(_ obj:Any?) -> String?{
        if JSONSerialization.isValidJSONObject(obj),
            let obj = obj,
            let data = try? JSONSerialization.data(withJSONObject: obj, options: []){
            return (String(bytes: data, encoding: .utf8))
        }
        return nil
    }
    
    public static func parse(_ data:Data?) -> AnyObject{
        if let data = data{
            do{
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
            }catch{
                return emptyObject
            }
        }
        return emptyObject
    }
    
    public static func parse(_ str:String?) -> AnyObject{
        let data = str?.data(using:.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            
            do{
                // Will return an object or nil if JSON decoding fails
                return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject
            }catch{
                return emptyObject
            }
        } else {
            // Lossless conversion of the string was not possible
            return emptyObject
        }
    }
    
    static var emptyObject:AnyObject {
        [String: AnyObject]() as AnyObject
    }
}

public extension Dictionary where Key == String{
    func stringify()->String?{
        return JSON.stringify(self)
    }
}

public extension NSObject{
    func stringify()->String?{
        return JSON.stringify(self)
    }
}


public extension Encodable{
    func stringify()->String?{
        if let data = try? JSONEncoder().encode(self){
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
        return nil
    }
}
