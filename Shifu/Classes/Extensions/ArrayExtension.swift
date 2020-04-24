//
//  ArrayExtension.swift
//  aSong
//
//  Created by Baoli Zhai on 2019/4/19.
//  Copyright © 2019 Baoli Zhai. All rights reserved.
//

import Foundation


extension Array {
    public func get( _ index: Int, _ defaultValue:Element? = nil) -> Element? {
        var index = index;
        if index < 0{
            index = self.count + index;
        }
        return index < count && index >= 0 ? self[index] : defaultValue
    }
}
