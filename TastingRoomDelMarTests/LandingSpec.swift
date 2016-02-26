//
//  LandingSpec.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/25/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import TastingRoomDelMar


class LandingSpec: QuickSpec {
    
    override func spec() {
        describe("sorting integers") {
            var values: [Int] = []
            
            beforeEach {
                values = [2, 5, 3]
            }
            
            it("reorders smaller integers first in the array") {
                values.sortInPlace()
                expect(values).to(equal([2, 3, 5]))
            }
            
        }
        
    }
    
}
