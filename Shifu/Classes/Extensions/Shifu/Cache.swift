//
//  Cache.swift
//  Shifu
//
//  Created by Baoli Zhai on 2023/9/3.
//

import SwiftUI

public class Cache:ObservableObject {
    @Published private(set) var value: Any?
    private var hash:Int?
    
    public init( ) {  }
    
    @discardableResult public func define(_ dependencies: [(any Hashable)?], recalculation:  @escaping (()->Any?))->Any?{
        return update(dependencies, recalculation: recalculation)
    }
    
    public func get(_ dependencies: [(any Hashable)?])->Any?{
        return update(dependencies)
    }
    
    @discardableResult private func update(_ dependencies: [(any Hashable)?], recalculation:  (()->Any?)? = nil)->Any?{
        var hasher = Hasher()
        for d in dependencies {
            if let d = d{
                hasher.combine(d)
            }
        }
        let latestHash = hasher.finalize()
        if(hash != latestHash){
            value = recalculation?()
            hash = latestHash
        }
        return value
        
        
    }
}
