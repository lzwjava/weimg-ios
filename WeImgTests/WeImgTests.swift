//
//  WeImgTests.swift
//  WeImgTests
//
//  Created by lzw on 16/1/28.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import XCTest
@testable import WeImg

class WeImgTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func wait() {
        expectationForNotification("WeImgTest", object: nil
            , handler: nil);
        waitForExpectationsWithTimeout(30, handler: nil);
    }
    
    func notify() {
        NSNotificationCenter.defaultCenter().postNotificationName("WeImgTest", object: nil);
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        PostManager.manager.getPost { (posts:[Post], error: NSError?) -> Void in
            self.notify()
        }
        wait()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
