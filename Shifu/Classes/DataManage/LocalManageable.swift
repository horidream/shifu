//
//  LocalManageable.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 15/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import FMDB

public protocol LocalManageable {
    var id:Int64? { get  set }
    static var localStorage:LocalStorage { get }
    
    mutating func create()
    func update()
    func delete()
    
    init(_ rst:FMResultSet)
}

public extension LocalManageable{
    public static func fetch(_ query:String, args:[Any]! = [])->[Self]{
        return localStorage.query(query, args: args) { (rst) -> Self? in
            return self.init(rst)
        }
    }
    
    public mutating func save(){
        if id != nil{
            update()
        }else{
            create()
        }
    }
    
    public func delete(){
        if let id = id{
            _ = self.localStorage.exe("delete from ? where id = ?", args: [self.tableName, id])
        }
    }
    
    public var localStorage:LocalStorage  {
        return Self.localStorage
    }
    
    public var tableName:String {
        return String(describing: type(of: self))
    }
    
}
