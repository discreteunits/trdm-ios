//
//  TierUnitTests.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 3/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import XCTest

@testable import TastingRoomDelMar


class TierUnitTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testTierITakeOut() {
        let app = XCUIApplication()
        // 1
        let tableQuery = app.descendantsMatchingType(.Table)
        
//        // 2
//        let tierITable = tableQuery["Tier One Table"]
//        let cellQuery = tierITable.childrenMatchingType(.Cell)
//        
//        let identifier = "Take Out"
//        let tierIQuery = cellQuery.containingType(.StaticText, identifier: identifier)
//        let tierICell = tierIQuery.element
//        tierICell.tap()
        
//        // 3
//        let navBarQuery = app.descendantsMatchingType(.NavigationBar)
//        let navBar = navBarQuery[identifier]
//        let buttonQuery = navBar.descendantsMatchingType(.Button)
//        let backButton = buttonQuery["Del Mar"]
//        backButton.tap()
        
        
    }
    
}
