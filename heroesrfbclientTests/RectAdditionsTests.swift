//
//  RectAdditionsTests.swift
//  RectAdditionsTests
//
//  Created by sbuglakov on 03/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import XCTest

class RectAdditionsTests: XCTestCase {
    
    func testTranslatesWithZeroOrigin() {
        let a = CGRect(x: 1, y: 2, width: 3, height: 4).rectInsideRect(CGRect(x: 0, y: 0, width: 5, height: 5))
        XCTAssertEqual(a.origin.x, 1)
        XCTAssertEqual(a.origin.y, 2)
        XCTAssertEqual(a.size.width, 3)
        XCTAssertEqual(a.size.height, 3)
    }
    
    func testTranslatesWithOrigin() {
        let a = CGRect(x: 1, y: 2, width: 3, height: 4).rectInsideRect(CGRect(x: 2, y: 2, width: 5, height: 5))
        XCTAssertEqual(a.origin.x, 0)
        XCTAssertEqual(a.origin.y, 0)
        XCTAssertEqual(a.size.width, 3)
        XCTAssertEqual(a.size.height, 4)
    }
    
}
