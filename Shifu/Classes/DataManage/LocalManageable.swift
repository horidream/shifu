//
//  LocalManageable.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 15/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import CloudKit
import FMDB


public protocol LocalManageableDelegate{
    
    var localStorage:LocalStorage{get}
    mutating func create()
    func update()
    func delete()
    
}

public protocol CloudManageableDelegate{
    mutating func create(complete:@escaping(AsyncResponse)->Void)
    func update(complete:@escaping(AsyncResponse)->Void)
    func delegate(complete:@escaping(AsyncResponse)->Void)
}

public protocol Manageable {
    var localDelegate:LocalManageableDelegate? { get set }
    var cloudDelegate:CloudManageableDelegate? {get set}
    var id:Int64? { get }
    var record:CKRecord? {get set}
    init(_ rst:FMResultSet)
    init(_ record:CKRecord)
    
    
}

public extension Manageable{
    public mutating func save(){
        if id != nil{
            localDelegate?.update()
        }else{
            localDelegate?.create()
        }
    }
    
    public func delete(){
        if let id = id{
            _ = localDelegate?.localStorage.exe("delete from ? where id = ?", args: [self.tableName, id])
        }
    }

    public var tableName:String {
        return String(describing: type(of: self))
    }
    
}
