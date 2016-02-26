//
//  TastingRoomDelMarTests.swift
//  TastingRoomDelMarTests
//
//  Created by Tobias Robert Brysiewicz on 1/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
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
    
    func testUIAlertViewAfterViewLoads() {
        class FakeAlertView: UIAlertController {
            var showWasCalled = false

            private func show() {
                showWasCalled = true
            }
            
        }
        
        let vc = LandingViewController()
        vc.alertView = FakeAlertView()
        
        vc.viewDidLoad()
        XCTAssertTrue((vc.alertView as FakeAlertView).showWasCalled, "Show was not called.")
        
    }
    
}
