//
//  ShifuSQLite.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/4/19.
//

import Foundation
import FMDB




public class ShifuSQLite{
    public var db:FMDatabase
    public var lastInsertRowId:Int64{
        return db.lastInsertRowId
    }
    
    public init(filename:String? = nil, overwritten:Bool = false){
        if let filename = filename{
            let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask, true)
            let path = paths.first!.appending("/\(filename)")
            if(overwritten){
                try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
            }
            db = FMDatabase(path: path)
        }else{
            db = FMDatabase(path: ":memory:")
        }
        db.open()
    }
    // MARK: - create/clear table
    /* Example: sql.create(tableName: "BookMark", schema: "id INTEGER PRIMARY KEY, fileHash TEXT, startPosition REAL, type INTEGER default 0, remark TEXT default \"\"")
     */
    public func create(tableName table:String, schema:String = "id INTEGER primary, name TEXT")
    {
        db.executeStatements("CREATE TABLE IF NOT EXISTS \(table) (\(schema))")
    }
    public func clear(tableName table:String){
        db.executeStatements("delete from \(table)")
    }
    
    // MARK: - getter
    public func querySequence<T>(_ sql:String, args:[Any]! = nil, map block:@escaping (FMResultSet)->T?)->AnySequence<T>{
        let rs = try? db.executeQuery(sql, values: args)
            return AnySequence{
                ()->AnyIterator<T> in
                return AnyIterator{
                    if let rs = rs{
                        if(rs.next()){
                            return block(rs);
                        }else{
                            return nil
                        }
                    }else{
                        return nil
                    }
                }
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
    
    public func queryOne<T>(_ sql:String, args:[Any]! = nil, map block:(FMResultSet)->T?)->T?{
        if let rs = try? db.executeQuery(sql, values: args) {
            if rs.next() {
                return block(rs)
            }
        }
        return nil
    }
    
    public func queryInt(_ sql:String, args:[Any]! = nil)->Int{
        return Int(self.queryOne(sql){ $0.int(forColumnIndex: 0)}!)
        
    }
    
    // MARK: - setter
    @discardableResult public func exe(_ sql:String, args:[Any]! = nil)->Bool{
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
    
    
    
    

    // MARK: - supporting
    public func rowExists(id:Int64)->Bool{
        
        do{
            let rs = try db.executeQuery("select id from items where id=?", values: [id])
            return rs.next()
        }catch{
            return false
        }
        
    }

}
