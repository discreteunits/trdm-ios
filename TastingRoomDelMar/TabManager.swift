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

    var tab = Tab()
    var openOrder = PFObject()
    
    override init() {
        
        // Create Tab Struct
        
        tab = Tab()
        print("New Tab Created: \(tab)")

        super.init()
    }
    
    
    func syncTab() {
        
        if tab.id != "" {
            
            print("Tab found with ID.")
            // Run query for tab with found ID
            let potentialOrder = tabQuery(tab.id)
            if potentialOrder != "" {
                openOrder = potentialOrder
            }
            
            
        } else {
            
            tab = Tab()
            print("Tab does not have an ID.")
            
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
    
    func tabQuery(id: String) -> PFObject {
        
        var orderToReturn = PFObject()
        
        let tabQuery:PFQuery = PFQuery(className: "Order")
            tabQuery.includeKey("objectId")
            tabQuery.whereKey("objectId", equalTo: id)
        
        tabQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded. 
                print("tabQueried has found orders")

                
                // Do something with the found objects.
                for object in objects! {
                    var objectState = object["state"]! as! String
                    if objectState == "open" {
                        
                        // Return OPEN order
                        orderToReturn = object
                        
                    } else {
                        
                        print("Object found does not have a state of OPEN.")
                        
                    }
                    
                }
                
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            
        }
        
        return orderToReturn
        
    }
    
    
    
}


