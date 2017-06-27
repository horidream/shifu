//
//  CloudManageable.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 15/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import CloudKit

struct AsyncResponse{
    let success:Bool
    let payload:Any!
}

protocol CloudManageable {
    static var cloudStorage:CloudStorage { get }
    func cloudSave(complete:@escaping(AsyncResponse)->Void)
    func cloudDelete(complete:@escaping(AsyncResponse)->Void)
    init(_ record:CKRecord)
}

extension CloudManageable{
    static func cloudQuery(_ query:CKQuery, callback: @escaping ([Self], Error?)->Void){
        return cloudStorage.query(query) { records, error in
            callback(records.map({ record in
                self.init(record)
            }), error)
        }
    }
    
    var cloudStorage:CloudStorage{
        return Self.cloudStorage
    }
    
    var recordName:String {
        return String(describing: type(of: self))
    }
}
