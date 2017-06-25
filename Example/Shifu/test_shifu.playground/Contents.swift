//: Playground - noun: a place where people can play

import UIKit
import Shifu
import FMDB


class Item:LocalManageable{
    static var localStorage: LocalStorage = LocalStorage(filename: "test.db")
    
    func create() {
        
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
    
    required init(_ rst: FMResultSet) {
        
    }
    
    init(){
        
    }
    
    
}

print("will go")
let item = Item()
print(item.tableName, item.localStorage)
let items = Item.fetch("select * from test.db")
print(items)
    

