//
//  Buildable.swift
//  Shifu
//
//  Created by Baoli Zhai on 2024/6/29.
//

import Foundation

public protocol Buildable{
    init(builder: (Self)->Void)
}

public extension Buildable where Self:NSObject {
    init(builder: (Self)->Void){
        self.init()
        builder(self)
    }
}
