//
//  SQLLiteManager.swift
//  FMDB
//
//  Created by Baoli Zhai on 2019/4/14.
//

import Foundation
import FMDB


class SQLLiteManager{
    private var database:FMDatabase
    private var lastInsertRowId:NSNumber?
    private let forceOverwrite:Bool = false
    init(name: String){
        
        let bundlePath = Bundle.main.path(forResource: name, ofType: ".db")!
        let fm = FileManager.default
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        let path = NSString(string: documentsFolder).appendingPathComponent("\(name).db")
        if(!self.forceOverwrite){
            if(!fm.contentsEqual(atPath: bundlePath, andPath: path)){
                print("not same, overwriting")
                let data = NSData(contentsOfFile: bundlePath)
                data?.write(toFile: path, atomically: true)
            }
            
        }else{
            do{
                try fm.copyItem(atPath: bundlePath, toPath: path)
            }catch{
                print(error)
            }
        }
        self.database = FMDatabase(path: path)
    }
    
    var lastId:Int64{
        return database.lastInsertRowId
    }
    
    @discardableResult func exec(_ sql:String, args:[Any]! = nil)->Bool{
        guard self.database.open() == true else{
            return false
        }
        do{
            try database.executeUpdate(sql, values: args)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func fetch<T>(_ sql:String, args:[Any]! = nil, map block:(FMResultSet)->T)->Array<T>{
        var result:Array<T> = []
        guard self.database.open() == true else{
            return result
        }
        if let rs = database.executeQuery(sql, withArgumentsIn: args ?? []) {
            while rs.next() {
                result.append(block(rs))
            }
        }
        return result
    }
}

extension FMResultSet{
    func value<T>(forKey key: String) -> T? {
        switch T.self {
        case is String.Type:
            return self.string(forColumn: key) as? T
        default:
            return nil
        }
    }
}

