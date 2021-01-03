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
    
    @discardableResult
    func write(text: String, to fileName: String, appending:Bool = false, in directory: URL = url.document) -> String?{
        let filePath = directory.appendingPathComponent(fileName).path
        do{
            if !fileExists(atPath: filePath) {
                createFile(atPath: filePath, contents: text.data(using: .utf8), attributes: nil)
            }else{
                if(appending){
                    if let fileHandle = FileHandle(forWritingAtPath: filePath) {
                        defer {
                            fileHandle.closeFile()
                        }
                        fileHandle.seekToEndOfFile()
                        fileHandle.write(text.data(using: .utf8)!)
                    }
                }else{
                    try text.write(toFile: filePath, atomically: true, encoding: .utf8)
                }
            }
            return filePath
        }catch{
            return nil
        }
    }
    
    func read(_ fileName: String, in directory: URL = url.document) -> String?{
        let filePath = directory.appendingPathComponent(fileName).path
        return try? String(contentsOfFile: filePath)
    }
    
    func exists(_ fileName: String, in directory: URL = url.document) -> Bool{
        let filePath = directory.appendingPathComponent(fileName).path
        return fileExists(atPath: filePath)
    }
}
