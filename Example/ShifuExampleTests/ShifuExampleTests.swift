//
//  ShifuExampleTests.swift
//  ShifuExampleTests
//
//  Created by Baoli Zhai on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import Cuckoo
@testable import ShifuExample

class ShifuExampleTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testMockWithCockoo() throws {
        let originalTest = Test()
        XCTAssertEqual(originalTest.say(), "hello")
        
        let mockTest = MockTest()
        stub(mockTest){ stub in
            when(stub.say()).thenReturn("OK")
        }
        XCTAssertEqual(mockTest.say(), "OK")
        
    }
}
