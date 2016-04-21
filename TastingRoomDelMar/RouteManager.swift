//
//  RouteManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RouteManager: NSObject {

    static let sharedInstance = RouteManager()
    
    var TierOne: PFObject?
    var TierTwo: PFObject?
    var TierThree: PFObject?
    var TierFour: PFObject?
    
    var Route: [PFObject]? {
        var fullRoute: [PFObject]? = [PFObject]()
        
        if let tierI = TierOne {
            fullRoute?.append(tierI)
            if let tierII = TierTwo {
                fullRoute?.append(tierII)
                if let tierIII = TierThree {
                    fullRoute?.append(tierIII)
                    if let tierIV = TierFour {
                        fullRoute?.append(tierIV)
                        return fullRoute // Return Full Route
                    } else { return fullRoute } // Return @ TierThree
                } else { return fullRoute } // Return @ TierTwo
            } else { return fullRoute } // Return @ TierOne
        } else { return fullRoute } // Return NOTHING
        
    }
    
    func printRoute() {
        print("+++++ ROUTE ++++++")
        for index in 0 ..< Route!.count {
           print("Route \(index): \(Route![index]["name"])")
        }
        print("++++++++++++++++++")
    }
    
    func resetRoute() {
        TierOne = nil
        TierTwo = nil
        TierThree = nil
        TierFour = nil
    }
    
    
    
}

