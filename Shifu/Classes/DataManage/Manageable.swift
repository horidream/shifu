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


public struct AsyncResponse{
    public let success:Bool
    public let payload:Any!
    public init(success:Bool, payload:Any!){
        self.success = success
        self.payload = payload
    }
}

public protocol CloudManageableDelegate{
    var cloudStorage:CloudStorage{get}
    mutating func create(complete:@escaping(AsyncResponse)->Void)
    func update(complete:@escaping(AsyncResponse)->Void)
    func delete(complete:@escaping(AsyncResponse)->Void)
}


public protocol LocalManageable{
    var localDelegate:LocalManageableDelegate? { get set }
    var id:Int64? { get }
    init(_ rst:FMResultSet)
}

public protocol CloudManageable{
    var cloudDelegate:CloudManageableDelegate? {get set}
    var record:CKRecord? {get set}
    init(_ record:CKRecord)
}

public protocol Manageable: LocalManageable, CloudManageable {
}

public extension Manageable{
    public mutating func save(){
        if id != nil{
            localDelegate?.update()
            cloudDelegate?.update(complete: { (response) in
                // to do
            })
        }else{
            localDelegate?.create()
            cloudDelegate?.create(complete: { (response) in
                // to do
            })
        }
    }
    
    public func remove(){
        localDelegate?.delete()
        cloudDelegate?.delete(complete: { (response) in
            // to do
        })
    }

    public var tableName:String {
        return String(describing: type(of: self))
    }
    
}
