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
    
    //                            (quantity * price) * ( taxRatesTotal / 10000 )
    
    func totalCellCalculator() {
        
        var subtotal = Double()
        var totalTax = Double()
        
        let lineitems = currentTab.lines
        for lineitem in lineitems {
            
            // Tax Calculations
            totalTax = totalTax + lineitem.tax // Already in dollars
        
            // Subtotal Calculations
            subtotal = subtotal + lineitem.price // Already in dollars
            
        }
        
        // Total Calculation
        let total = totalTax + subtotal
        
        // Assignments
        currentTab.subtotal = subtotal
        currentTab.totalTax = totalTax
        currentTab.grandTotal = total
        
        print("Current Tab Totals Calculated: \(currentTab)")
        
    }
    
    
    // Place Order To CLOUDCODE
    func placeOrder(tab: Tab) -> AnyObject {
        
        print("-----------------------")
        print("Tab For CloudCode Order: \(tab)")
        print("-----------------------")

        // OPTION 1: Create Object
        var lines = [[String:AnyObject]]()
        var mods = [[String:AnyObject]]()

        // Loop Thru LineItems
        for lineitem in tab.lines {
            
            // Loop Thru Mods
            for mod in lineitem.modifiers {
                let paraMod : [String:AnyObject] = [
                    "id": mod.id
                ]
                mods.append(paraMod)
            }
            
            // Detailed Elements Container
            let smallElements : [String:AnyObject] = [
                "elements": mods
            ]
            
            // Loop Thru Items
            let paraLine : [String:AnyObject] = [
                "id": lineitem.id,
                "quantity": lineitem.quantity,
                "modifiers": smallElements
            ]
            
            lines.append(paraLine)
        }
        
        // Elements Container
        let elements : [String:AnyObject] = [
            "elements": lines
        ]
        
        // Build Params
        let para : [String:AnyObject] = [
            "id": tab.id,
            "note": tab.note,
            "table": tab.table,
            "userId": tab.userId,
            "lineItems": elements
        ] // end para
        
        // Create Order Object
        var order : [String:AnyObject] = [
            "order": para
        ]
        print("Order Equals: \(order)")
        
        
        // OPTION 1: Convert Object To JSON
//        let jsonObject: NSData
//        let aJSONString: NSString
//        do {
//            jsonObject = try NSJSONSerialization.dataWithJSONObject(para, options: NSJSONWritingOptions.PrettyPrinted)
//            aJSONString = NSString(data: jsonObject, encoding: NSUTF8StringEncoding) as! String
//        } catch _ {
//            print("UH OHH")
//            return "Failed"
//        }
        
// --------------------
        
//        // OPTION 2: Create Object
//        let params:NSMutableDictionary = NSMutableDictionary()
//            params.setValue(tab.id, forKey: "id")
//            params.setValue(tab.note, forKey: "note")
//            params.setValue(tab.table, forKey: "table")
//            params.setValue(tab.userId, forKey: "userId")
//            params.setValue(tab.lines, forKey: "lineItems")
//        
//
//        
//        
//        // OPTION 2: Convert Object To JSON
//        let jsonData: NSData
//        do {
//            
//            jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
//            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
//            print("JSON STRING: \(jsonString)")
//        
//        } catch _ {
//            
//            print("UH OH")
//            return "Failed"
//            
//        }
        
// ---------------------
       
        var result = String()
        
        print("-----------------------")
        print("Params Built: \(para)")
        print("-----------------------")

        
        // Send Object To CloudCode
        PFCloud.callFunctionInBackground("placeOrder", withParameters: para ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                
                // Failure 
                print("Error: \(error)")
                
            } else {
                
                // Success 
                result = String(response!)
                print("Response: \(response!)")
                
                
            }
            
        }
        
        return result
        
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


