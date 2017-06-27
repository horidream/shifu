//
//  CloudStorage.swift
//  ScrumSolo
//
//  Created by Baoli Zhai on 14/05/2017.
//  Copyright © 2017 DreamStudio. All rights reserved.
//

import Foundation
import CloudKit

class CloudStorage{
    private var container:CKContainer = CKContainer.default()
    public var privateDB:CKDatabase{
        return container.privateCloudDatabase
    }
    
    func query(_ query:CKQuery, zoneId:CKRecordZoneID? = nil, callback:@escaping ([CKRecord], Error?)->Void){
        privateDB.perform(query, inZoneWith: zoneId) { (records, error) in
            let empty = Array<CKRecord>()
            if error == nil{
                callback(records ?? empty, nil)
            }else{
                callback(empty, error)
            }
        }
    }
    
    func modify(recordsToSave records: [CKRecord]?, recordIDsToDelete recordIDs: [CKRecordID]? = nil, callback:(([CKRecord]?, [CKRecordID]?, Error?) -> Void)?){
        
        let op = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: recordIDs)
        op.modifyRecordsCompletionBlock = callback
        privateDB.add(op)
    }
    
}
