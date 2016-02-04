//
//  TabManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/28/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class TabManager: NSObject {

    static let sharedInstance = TabManager()
    
    var currentTab = Tab()
    
// -------------------
    override init() {
        super.init()
        
        currentTab.id = "qSprPWBN6T"
        
        print("Current Tab id Spoofed \(currentTab)")
        
        
        
        // Find or Create Order
//        self.syncTab()

    }
    
    
    func syncTab(tabId: String) {
        
        if currentTab.id != "" {
            
            print("Current tab has an ID.")
            
            // Run query for tab with found ID
            tabQuery(tabId)
            
            print("Order found that matches tab: \(currentTab)")
            
            
        } else {
            
            currentTab = Tab()
            print("New Tab Created: \(currentTab)")
            
        }
        
    }
    
    func addToTab() {
        
    }
    
    func removeFromTab() {
        
    }
    
    func placeOrder() {
        
    }
    
    func clearTab() {
        
    }
    
    func tabQuery(id: String) {
        
        let tabQuery:PFQuery = PFQuery(className: "Order")
            tabQuery.whereKey("objectId", equalTo: id)
        
        tabQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded. 
                print("Tab query has found \(objects!.count) orders.")
                print("---------------------")

                
                // Do something with the found objects.
                for object in objects! {
                    
                    let objectState = object["state"]! as! String
                    
                    // Check if found order is open still
                    if objectState == "open" {
                        
                        // Do what you came here to do
                        self.currentTab.state = object["state"] as! String

                        
                    } else {
                        
                        print("Object found does not have a state of OPEN.")
                        
                    }
                    
                }
                
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            
        }
        
    }
    
}


