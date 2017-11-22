//
//  Database.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 09/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import FMDB



public class LocalStorage {
    
    private var db:FMDatabase
    public var lastInsertRowId:Int64{
        return db.lastInsertRowId
    }
    
    public init(filename:String, overwritten:Bool = false){
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)
        let path = paths.first!.appending("/\(filename)")
        if(overwritten){
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        db = FMDatabase(path: path)
        db.open()
    }
    
    
    public func create(tableName table:String, schema:String)
    {
        db.executeStatements("CREATE TABLE IF NOT EXISTS \(table) (\(schema))")
    }
    
    public func fetch<T:Manageable>(_ query:String, args:[Any]! = [])->[T]{
        return self.query(query, args: args) { (rst) -> T? in
            return T.init(rst)
        }
    }
    
    
    
    public func exe(_ sql:String, args:[Any]! = nil)->Bool{
        var result:Bool
        if args == nil || args.count == 0{
            result = db.executeStatements(sql)
        }else{
            result = db.executeUpdate(sql, withArgumentsIn: args)
        }
        if(!result){
            print(db.lastError())
        }
        return result
    }
    
    public func rowExists(id:Int64)->Bool{
        
        do{
            let rs = try db.executeQuery("select id from items where id=?", values: [id])
            return rs.next()
        }catch{
            return false
        }
        
    }
    
    public func query<T>(_ sql:String, args:[Any]! = nil, map block:(FMResultSet)->T?)->Array<T>{
        var result:Array<T> = []
        if let rs = try? db.executeQuery(sql, values: args) {
            while rs.next() {
                if let r = block(rs){
                    result.append(r)
                }
            }
        }
        return result
    }
    
    public func clear(tableName table:String){
        db.executeStatements("delete from \(table)")
    }
    
    public func delete(){
        
    }
}


