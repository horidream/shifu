//
//  ShortCutTests.swift
//  ShifuExampleTests
//
//  Created by Baoli Zhai on 2022/11/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import Shifu
@testable import ShifuExample

final class ShortCutTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        sc.off("hello")
    }

    func testNotificaitonShouldReceiveAllNotificationIfNoObjectSpecified() throws {
        var notificationReceived = false
        var count = 0
        sc.on("hello") { notification in
            count += 1
            notificationReceived = notification.userInfo?["hello"] as? Bool ?? false
        }
        sc.emit("hello", object: self, userInfo: ["hello": true])
        XCTAssert(notificationReceived, "Notification not should be received")
        XCTAssert(count == 1)
        sc.emit("hello", userInfo: ["hello": true])
        XCTAssert(count == 2)
        sc.emit("hello")
        XCTAssert(count == 3)
        sc.emit("world")
        XCTAssert(count == 3)
    }
    
    func testNotificaitonShouldBeReceivedWithNoObjectSpecified() throws {
        var notificationReceived = false
        sc.on("hello") { notification in
            notificationReceived = true
        }
        sc.emit("hello", object: self)
        XCTAssert(notificationReceived)
        XCTAssert(notificationMap["hello".toNotificationName()]?.count == 1)
        sc.off("hello")
        XCTAssert(notificationMap["hello".toNotificationName()] == nil)
        notificationReceived = false
        sc.on("hello", object: 1) { notification in
            notificationReceived = true
        }
        sc.emit("hello")
        XCTAssert(!notificationReceived)
        sc.emit("world", object: 1)
        XCTAssert(!notificationReceived)
        sc.emit("hello", object: 2)
        XCTAssert(!notificationReceived)
        sc.emit("hello", object: 1)
        XCTAssert(notificationReceived)
    }

    func testNotificaitonShouldNotBeReceivedWithDifferentObject() throws {
        var notificationReceived = false
        let a = Test()
        let b = Test()
        sc.on("hello", object: a) { notification in
            notificationReceived = true
        }
        sc.emit("hello", object: b, userInfo: ["hello": true])
        XCTAssert(!notificationReceived, "Notification should not be received with different object")
        sc.emit("hello", object: a, userInfo: ["hello": true])
        XCTAssert(notificationReceived, "Notification should be received with same object")
        
    }
    
    func testNotificaitonWithNonClassObject() throws {
        var notificationReceived = false
        let a = 1
        let b = 2
        sc.on("hello", object: a) { notification in
            notificationReceived = true
        }
        sc.emit("hello", object: b, userInfo: ["hello": true])
        XCTAssert(!notificationReceived, "Notification should not be received with different object")
        sc.emit("hello", object: a, userInfo: ["hello": true])
        XCTAssert(notificationReceived, "Notification should be received with same object")
        
    }


}
