//
//  LocalManageable.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 15/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import FMDB

protocol LocalManageable {
    static var localStorage:LocalStorage { get }
    
    func save()
    func delete()
    init(_ rst:FMResultSet)
}

extension LocalManageable{
    static func query(_ sql:String, args:[Any]! = [])->[Self]{
        return localStorage.query(sql, args: args) { (rst) -> Self? in
            return self.init(rst)
        }
    }
    
    var localStorage:LocalStorage  {
        return Self.localStorage
    }
    
    var tableName:String {
        return String(describing: type(of: self))
    }
    
}
