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
        public static var temp:URL{
            return FileManager.default.temporaryDirectory
        }
        public static var cache:URL{
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
        public static var setting:URL{
            return UIApplication.openSettingsURLString.url!
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
            let p = NSTemporaryDirectory()
            if p.substr(-1) == "/" {
                return p.substring(0, -1)
            }
            return p
        }
    }
    
    @discardableResult
    func write(text: String, to fileName: String, appending:Bool = false, in directory: URL = url.document) -> String?{
        return write(data: text.data(using: .utf8), to: fileName, appending: appending, in: directory)
    }
    
    @discardableResult func write(data: Data?, to fileName: String, appending:Bool = false, in directory: URL = url.document) -> String?{
        guard data != nil else { return nil }
        let fileURL = directory.appendingPathComponent(fileName)
        let dirURL = fileURL.deletingLastPathComponent()
        let filePath = fileURL.path
        clg(dirURL)
        do{
            if !fm.dirExists(dirURL.path){
                try fm.createDirectory(at: dirURL, withIntermediateDirectories: true)
            }
            if !fileExists(atPath: filePath) {
                createFile(atPath: filePath, contents: data, attributes: nil)
            }else{
                if(appending){
                    if let fileHandle = FileHandle(forWritingAtPath: filePath) {
                        defer {
                            fileHandle.closeFile()
                        }
                        fileHandle.seekToEndOfFile()
                        fileHandle.write(data!)
                    }
                }else{
                    try data!.write(to: fileURL, options: .atomic)
                }
            }
            return filePath
        }catch{
            return nil
        }
    }
    
    func read(_ fileName: String, in directory: URL = url.document) -> String?{
        let filePath = directory.appendingPathComponent(fileName).path
        if(filePath.url?.isFileURL ?? false){
            return try? String(contentsOfFile: filePath)
        }
        return nil
    }
    
    func dirExists(_ path:String) -> Bool{
        var isDirectory: ObjCBool  = true
        return fm.fileExists(atPath: path, isDirectory: &isDirectory)
    }
    
    func exists(_ fileName: String, in directory: URL = url.document) -> Bool{
        let filePath = directory.appendingPathComponent(fileName).path
        return fileExists(atPath: filePath)
    }
    
    func url(_ fileName: String, in directory: URL = url.document) -> URL{
        return directory.appendingPathComponent(fileName)
    }
    
    func urls(in url: URL?)->[URL]  {
        if let url , let enumerator = FileManager.default.enumerator(atPath:url.path){
            return enumerator.allObjects.map{ url.appendingPathComponent($0 as! String)}
        }else{
            return []
        }
    }
}


