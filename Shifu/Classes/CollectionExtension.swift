//
//  CollectionExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 27/01/2017.
//  Copyright © 2017 Baoli Zhai. All rights reserved.
//


extension Collection {
    /**
     Generate an Array for the Table View Index List
     
     - Parameter transform: transform block that transform Element to String type
     
     - Returns: Element grouped by first letter from A~Z and #.
     */
    public func dataForIndexList(transform:(Generator.Element)->String)->[String:[Generator.Element]]{
        
        var nd :[String:[Generator.Element]] = [:]
        self.forEach { (item) in
            let ll = transform(item).leadingLetter
            if !nd.keys.contains(ll){
                nd[ll] = []
            }
            nd[ll]?.append(item)
        }
        
        return nd
    }
}
