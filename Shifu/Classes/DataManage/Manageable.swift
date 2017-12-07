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
    mutating func create(_:LocalManageable)
    mutating func update(_:LocalManageable)
    mutating func delete(_:LocalManageable)
    
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
    mutating func create(_:CloudManageable, complete:@escaping(AsyncResponse)->Void)
    func update(_:CloudManageable, complete:@escaping(AsyncResponse)->Void)
    func delete(_:CloudManageable, complete:@escaping(AsyncResponse)->Void)
}


public protocol LocalManageable{
    var localDelegate:LocalManageableDelegate? { get set }
    var id:Int64? {get set}
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
        let this = self
        if id != nil{
            localDelegate?.update(this)
            cloudDelegate?.update(this,complete: { (response) in
                // to do
            })
        }else{
            localDelegate?.create(this)
            cloudDelegate?.create(this, complete: { (response) in
                // to do
            })
        }
    }
    
    mutating public func delete(){
        let this = self
        localDelegate?.delete(this)
        cloudDelegate?.delete(this, complete: { (response) in
            // to do
        })
    }

    public var tableName:String {
        return String(describing: type(of: self))
    }
    
}
