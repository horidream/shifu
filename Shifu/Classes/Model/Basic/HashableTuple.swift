//
//  HashableTuple.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/1.
//

import Foundation

struct HashableTuple: Hashable{
    let a: AnyHashable
    let b: AnyHashable
    
    init(_ a:AnyHashable, _ b: AnyHashable){
        self.a = a
        self.b = b
    }
}
