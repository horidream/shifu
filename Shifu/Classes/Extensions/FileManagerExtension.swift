//
//  FileManagerExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/6.
//

import Foundation

public extension FileManager {
    struct url{
        public static var document:URL{
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        public static var cache:URL{
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
    }
    struct path{
        public static var document:String{
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
            return paths.first!
        }
        public static var cache:String{
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
            return paths.first!
        }
        public static var temp:String{
            return NSTemporaryDirectory()
        }
    }
}
