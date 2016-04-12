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
    
    var tierIVToTab = false
    
// -------------------
    override init() {
        super.init()
        

        // Find or Create Order
//        self.syncTab()

    }
    
    func syncTab(tabId: String) {
        
        // Look for order in DB
        if currentTab.id != "" {
            
            if printFlag {
                print("Current tab has an ID.")
            }
            
            // Run query for tab with found ID
            tabQuery(tabId)
            
            if printFlag {
                print("Order found that matches tab: \(currentTab)")
            }
            
        // Initialize new tab
        } else {
            
            currentTab = Tab()
            
            if printFlag {
                print("New Tab Created: \(currentTab)")
            }
            
        }
        
    }
    
    func totalCellCalculator() {
        
        var subtotal = Double()
        var totalTax = Double()
        
        
        // ----- HARVEST BEGIN ------
        let lineitems = currentTab.lines
        for lineitem in lineitems {
            
            var values = Double()
            if lineitem.path == "Eat" {
                for addition in lineitem.additions {
                    for value in addition.values {
                        values = values + Double(value.price)!
                    }
                }
            }
            
            let allAdditionValuePrices = values * Double(lineitem.quantity)
            
            // Tax Calculations
            totalTax = totalTax + lineitem.tax // Already in dollars
        
            // Subtotal Calculations
            subtotal = subtotal + lineitem.price + allAdditionValuePrices // Already in dollars
            
        }
        // ----- END -----

        
        // Total Calculation
        let total = totalTax + subtotal
        
        // Assignments
        currentTab.subtotal = subtotal
        currentTab.totalTax = totalTax
        currentTab.grandTotal = total
        
        if printFlag {
            print("Current Tab Totals Calculated: \(currentTab)")
        }
        
    }
    
    func gratuityCalculator(gratuity: String) {
        
        // If Cash
        if gratuity == "Cash" {
            
            currentTab.gratuity = 0.0
            
        // If NOT Cash - Convert String To Double And Calculate
        } else {
            
            let gratuityDouble = Double(gratuity)! / 100
            
            
            let gratuityAmount = (currentTab.grandTotal * gratuityDouble)
            let gratuityTotal = currentTab.grandTotal + (currentTab.grandTotal * gratuityDouble)

            currentTab.gratuity = gratuityAmount
            currentTab.grandTotal = gratuityTotal
            
            if printFlag {
                print("Customer Agreed To Tip:\(gratuityAmount)")
                print("Grand Total Recalculated: \(currentTab.grandTotal)")
            }
            
        }
        
    }
    
    // Place Order To CLOUDCODE
    func placeOrder(tab: Tab) -> AnyObject {
        
        if printFlag {
            print("-----------------------")
            print("Tab For CloudCode Order: \(tab)")
            print("-----------------------")
        }

        // Collection Storage For Build
        var lines = [[String:AnyObject]]()
        var modifiers = [[String:AnyObject]]()

        // BEGIN COLLECTING HERE
        for lineitem in tab.lines {


            // ----- HARVEST BEGIN ------
            for line in TabManager.sharedInstance.currentTab.lines {
                
                if line.path == "Eat" {
                   
                    for addition in line.additions {
                        
                        for value in addition.values {
                            
                            let paramModifier : [String:AnyObject] = [
                                "modifierId": value.modifierId,
                                "modifierValueId": addition.modifierValueId
                            ]
                            
                            modifiers.append(paramModifier)
                            
                        }
                        
                    }
                
                }
                
            }
            // ----- END -----


            
            // Begin Building LineItem
            //-----------------            
            // Loop LineItems
            let paramLineItem : [String:AnyObject] = [
                "amount": lineitem.quantity,
                "objectId": lineitem.subproduct.objectId,
                "productId": Int(lineitem.subproduct.productId)!,
                "modifiers": modifiers
            ]
            
            lines.append(paramLineItem)
            
        }
        
        let paramBody : [String:AnyObject] = [
            "type": tab.type,
            "orderItems": lines,
            "description": "Spoofed",
            "note": "Spoofer",
            "tipAmount": tab.gratuity
        ]
        
        // Build Params
        let para : [String:AnyObject] = [
            "userId": tab.userId,
            "checkoutMethod": tab.checkoutMethod,
            "table": tab.table,

            "body": paramBody
        ]
        
        // Create Order Object
        let order : [String:AnyObject] = [
            "order": para
        ]
        
        if printFlag {
            print("Order Equals: \(order)")
        }
        
        // Begin Placing Order with Order Object
        var result = String()
        
        // Send Object To CloudCode
        PFCloud.callFunctionInBackground("placeOrder", withParameters: order ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                
                // Failure 
                if printFlag {
                    print("Error: \(error)")
                }
                
            } else {
                
                // Success 
                result = String(response!)
                
                if printFlag {
                    print("Response: \(response!)")
                }
                
                // Reset Tab
                TabManager.sharedInstance.currentTab = Tab()
                
                if printFlag {
                    print("TabManager Reset: \(TabManager.sharedInstance.currentTab)")
                }
                
                // Reset Segue Push Stack
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.resetToMenu()
                
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
                if printFlag {
                    print("Tab query has found \(objects!.count) orders.")
                    print("---------------------")
                }
                
                // Do something with the found objects.
                for object in objects! {
                    
                    let objectState = object["state"]! as! String
                    
                    // Check if found order is open still
                    if objectState == "open" {
                        
                        // Do what you came here to do
                        self.currentTab.state = object["state"] as! String

                        
                    } else {
                        
                        if printFlag {
                            print("Object found does not have a state of OPEN.")
                        }
                        
                    }
                    
                }
                
                
            } else {
                
                // Log details of the failure
                if printFlag {
                    print("Error: \(error!) \(error!.userInfo)")
                }
                
            }
            
        }
        
    }
    
    
    func addItemsIndicator() {
        
        let itemsInTab = TabManager.sharedInstance.currentTab.lines.count
        let currentWindow: UIWindow = UIApplication.sharedApplication().keyWindow!

        removeItemsIndicator()
        
        currentWindow.reloadInputViews()

        // Only Show If LineItems Exist
        if itemsInTab > 0 {
        
            let windowWidth = currentWindow.bounds.width
        
            // Tab Quantity Indicator
            let itemsIndicator = UILabel(frame: CGRectMake(0, 0, 16, 16))
            itemsIndicator.frame.origin.y = 22
            itemsIndicator.frame.origin.x = windowWidth - 82
            itemsIndicator.text = "\(itemsInTab)"
            itemsIndicator.font = UIFont(name: "OpenSans", size: 10)
            itemsIndicator.layer.zPosition = 0
            itemsIndicator.backgroundColor = UIColor.redColor()
            itemsIndicator.textColor = UIColor.whiteColor()
            itemsIndicator.textAlignment = .Center
            itemsIndicator.layer.borderColor = UIColor.whiteColor().CGColor
            itemsIndicator.layer.borderWidth = 1.5
            itemsIndicator.layer.cornerRadius = 8
            itemsIndicator.clipsToBounds = true
            itemsIndicator.tag = 31
        
            // Add itemsIndicator
            currentWindow.addSubview(itemsIndicator)
        
            currentWindow.reloadInputViews()
            
        }
        
    }
    
    func removeItemsIndicator() {
        
        // Remove Indicator
        let currentWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        
        if let viewWithTag = currentWindow.viewWithTag(31) {
            viewWithTag.removeFromSuperview()
        }
        
    }
    
}