//
//  ArrayExtension.swift
//  aSong
//
//  Created by Baoli Zhai on 2019/4/19.
//  Copyright © 2019 Baoli Zhai. All rights reserved.
//

import Foundation


extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
}
