//
//  TastingRoomDelMarTests.swift
//  TastingRoomDelMarTests
//
//  Created by Tobias Robert Brysiewicz on 1/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import XCTest

@testable import TastingRoomDelMar

class TastingRoomDelMarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsEmailValid() {
        
        let validEmails = ["tbrysiewicz@gmail.com", "tbrysiewicz@yahoo.com", "tbrysiewicz@att.net"]
        let invalidEmails = ["123", "456", "789"]
        
        
        for validEmail in validEmails {
            XCTAssertEqual(Validator.isEmailValid(validEmail), true)
        }
        
        for invalidEmail in invalidEmails {
            XCTAssertEqual(Validator.isEmailValid(invalidEmail), false)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
