//
//  os.swift
//  Shifu
//
//  Created by Baoli Zhai on 2018/5/3.
//

import Foundation


public class os{
    public class path{
        public static var DOCUMENT:URL  {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
}
