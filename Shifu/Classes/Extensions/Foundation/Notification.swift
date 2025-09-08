//
//  Notification.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/2/13.
//

import Foundation

public extension Notification.Name{
    static var MOUNTED = "mounted".toNotificationName()
    static var LOADED = "loaded".toNotificationName()
    static var READY = "ready".toNotificationName()
}
