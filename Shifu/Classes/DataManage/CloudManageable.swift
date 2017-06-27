//
//  CloudManageable.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 15/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import CloudKit

public struct AsyncResponse{
    public let success:Bool
    public let payload:Any!
    public init(success:Bool, payload:Any!){
        self.success = success
        self.payload = payload
    }
}

public protocol CloudManageable {
    static var cloudStorage:CloudStorage { get }
    func cloudSave(complete:@escaping(AsyncResponse)->Void)
    func cloudDelete(complete:@escaping(AsyncResponse)->Void)
    init(_ record:CKRecord)
}

public extension CloudManageable{
    
    public static func cloudFetch(_ format:String, args:[Any]? = nil, callback:@escaping ([Self], Error?)->Void){
        let predicate = NSPredicate(format: format, argumentArray: args)
        let query = CKQuery(recordType: String(describing:type(of:self)), predicate: predicate)
        Self.cloudFetch(query, callback: callback)
    }
    
    public static func cloudFetch(_ query:CKQuery, callback: @escaping ([Self], Error?)->Void){
        return cloudStorage.query(query) { records, error in
            callback(records.map({ record in
                self.init(record)
            }), error)
        }
    }
    
    public var cloudStorage:CloudStorage{
        return Self.cloudStorage
    }
    
    public var recordName:String {
        return String(describing: type(of: self))
    }
}
