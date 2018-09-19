//
//  CloudStorage.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 14/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import CloudKit

public class CloudStorage{
    private var container:CKContainer = CKContainer.default()
    public var privateDB:CKDatabase{
        return container.privateCloudDatabase
    }
    public init(){
        
    }
    
    public func fetch<T:Manageable>(_ query:CKQuery, callback: @escaping ([T], Error?)->Void){
        return self.query(query) { records, error in
            callback(records.map({ record in
                T.init(record)
            }), error)
        }
    }
    
    public func fetch<T:Manageable>(_ format:String, args:[Any]? = nil, callback:@escaping ([T], Error?)->Void){
        let predicate = NSPredicate(format: format, argumentArray: args)
        let query = CKQuery(recordType: String(describing:type(of:self)), predicate: predicate)
        fetch(query, callback: callback)
    }
    
    public func query(_ query:CKQuery, zoneId:CKRecordZone.ID? = nil, callback:@escaping ([CKRecord], Error?)->Void){
        privateDB.perform(query, inZoneWith: zoneId) { (records, error) in
            let empty = Array<CKRecord>()
            if error == nil{
                callback(records ?? empty, nil)
            }else{
                callback(empty, error)
            }
        }
    }
    
    public func modify(recordsToSave records: [CKRecord]?, recordIDsToDelete recordIDs: [CKRecord.ID]? = nil, callback:(([CKRecord]?, [CKRecord.ID]?, Error?) -> Void)?){
        
        let op = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: recordIDs)
        op.modifyRecordsCompletionBlock = callback
        privateDB.add(op)
    }
    
}
