//
//  RouteManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/17/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseCrashReporting

class RouteManager: NSObject {

    static let sharedInstance = RouteManager()
    
    var currentRoute = Route()
    
    override init() {
        super.init()
        
    }
    
    func addToRoute(selection: PFObject, tier: String) {
        
        if tier == "TierI" {
            currentRoute.tierOne = selection
        } else if tier == "TierII" {
            currentRoute.tierTwo = selection
        } else if tier == "TierIII" {
            currentRoute.tierThree = selection
        } else if tier == "TierIVCollection" {
            currentRoute.tierFourCollection = selection
        } else if tier == "TierIVTable" {
            currentRoute.tierFourTable = selection
        }
        
    }
    
    func removeFromRoute(tier: String) {
        
        if tier == "TierI" {
            currentRoute.tierOne = PFObject()
        } else if tier == "TierII" {
            currentRoute.tierTwo = PFObject()
        } else if tier == "TierIII" {
            currentRoute.tierThree = PFObject()
        } else if tier == "TierIVCollection" {
            currentRoute.tierFourCollection = PFObject()
        } else if tier == "TierIVTable" {
            currentRoute.tierFourTable = PFObject()
        }
        
    }
    
    func printRoute() {
        
        print("------------------------------")
        print("Current Route: \(currentRoute)")
        print("------------------------------")
        
    }
    
    func resetRoute() {
        
        currentRoute.tierOne = PFObject()
        currentRoute.tierTwo = PFObject()
        currentRoute.tierThree = PFObject()
        currentRoute.tierFourCollection = PFObject()
        currentRoute.tierFourTable = PFObject()

    }

}
