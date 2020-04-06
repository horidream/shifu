//
//  FileManagerExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/6.
//

import Foundation

public extension FileManager {
    struct path{
        public static var document:String{
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
            return paths.first!
        }
        public static var cache:String{
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
            return paths.first!
        }
    }
}
