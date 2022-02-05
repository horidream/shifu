//
//  JSON.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/5.
//

import Foundation

public class JSON{
    public static func stringify(_ obj:AnyObject?) -> String{
        if let obj = obj, let data = try? JSONSerialization.data(withJSONObject: obj){
            return (String(bytes: data, encoding: .utf8)) ?? ""
        }
        return ""
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
