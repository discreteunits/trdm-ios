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
    
    var validTableNumbers = [String]()
    
    var crvObjects = [CRV]()
    
    // For Payment Back Button Condition
    var paymentToTab: Bool = true
    
    // Retail Bottle Counts for Discounts
    var discountObjects = [LineItem]()
    var discount15 = LineItem()
    var discount20 = LineItem()
    var discount25 = LineItem()
    var wineBottleCount: Int = 0
    var beerBottleCount: Int = 0
    
    
// -------------------
    override init() {
        super.init()

        // Find or Create Order
//        self.syncTab()

    }
    
    func retailBottleDiscount() {
        
        print("------------ Beginning to calculate potential discounts... -------------")
        print("Wine Bottle Count: \(wineBottleCount)")
        print("Beer Bottle Count: \(beerBottleCount)")
        print("-------------------------")
        
        
        // Begin Wine Discounting
        if wineBottleCount > 0 && wineBottleCount < 3 {
            // 15% Discount
            print("Applying 15% Wine Discount...")
            for var i in 0..<TabManager.sharedInstance.currentTab.lines.count {
                var lineitem = TabManager.sharedInstance.currentTab.lines[i]
                if lineitem.beerOrWine == "Wine" {
                    // Calculate LineItem's Total Discount
                    let lineitemSavings = (lineitem.price) * 0.15
                    lineitem.savings = lineitemSavings
                    // Insert Discount Object After Discountable Item
                    discount15.quantity = lineitem.quantity
                    discount15.price = lineitem.savings
                    TabManager.sharedInstance.currentTab.lines.insert(discount15, atIndex: i+1)
                }
            }

            
        } else if wineBottleCount > 2 && wineBottleCount < 12 {
            // 20% Discount
            print("Applying 20% Wine Discount...")
            for var i in 0..<TabManager.sharedInstance.currentTab.lines.count {
                var lineitem = TabManager.sharedInstance.currentTab.lines[i]
                if lineitem.beerOrWine == "Wine" {
                    // Calculate LineItem's Total Discount
                    let lineitemSavings = (lineitem.price) * 0.20
                    lineitem.savings = lineitemSavings
                    // Insert Discount Object After Discountable Item
                    discount20.quantity = lineitem.quantity
                    discount20.price = lineitem.savings
                    TabManager.sharedInstance.currentTab.lines.insert(discount20, atIndex: i+1)
                }
            }
            
            
        } else if wineBottleCount > 12 {
            // 25% Discount
            print("Applying 25% Wine Discount...")
            for var i in 0..<TabManager.sharedInstance.currentTab.lines.count {
                var lineitem = TabManager.sharedInstance.currentTab.lines[i]
                if lineitem.beerOrWine == "Wine" {
                    // Calculate LineItem's Total Discount
                    let lineitemSavings = (lineitem.price) * 0.25
                    lineitem.savings = lineitemSavings
                    // Insert Discount Object After Discountable Item
                    discount25.quantity = lineitem.quantity
                    discount25.price = lineitem.savings
                    TabManager.sharedInstance.currentTab.lines.insert(discount25, atIndex: i+1)
                }
            }
            
            
        }
        
        // Begin Beer Discounting
        if beerBottleCount > 0 && beerBottleCount < 3 {
            // 15% Discount
            print("Applying 15% Beer Discount...")
            for var i in 0..<TabManager.sharedInstance.currentTab.lines.count {
                var lineitem = TabManager.sharedInstance.currentTab.lines[i]
                if lineitem.beerOrWine == "Beer" {
                    // Calculate LineItem's Total Discount
                    let lineitemSavings = (lineitem.price) * 0.15
                    lineitem.savings = lineitemSavings
                    // Insert Discount Object After Discountable Item
                    discount15.quantity = lineitem.quantity
                    discount15.price = lineitem.savings
                    TabManager.sharedInstance.currentTab.lines.insert(discount15, atIndex: i+1)
                }
            }
            
            
        } else if beerBottleCount > 2 && beerBottleCount < 12 {
            // 20% Discount
            print("Applying 20% Beer Discount...")
            for var i in 0..<TabManager.sharedInstance.currentTab.lines.count {
                var lineitem = TabManager.sharedInstance.currentTab.lines[i]
                if lineitem.beerOrWine == "Beer" {
                    // Calculate LineItem's Total Discount
                    let lineitemSavings = (lineitem.price) * 0.20
                    lineitem.savings = lineitemSavings
                    // Insert Discount Object After Discountable Item
                    discount20.quantity = lineitem.quantity
                    discount20.price = lineitem.savings
                    TabManager.sharedInstance.currentTab.lines.insert(discount20, atIndex: i+1)
                }
            }
            
            
        } else if beerBottleCount > 12 {
            // 25% Discount
            print("Applying 25% Beer Discount...")
            for var i in 0..<TabManager.sharedInstance.currentTab.lines.count {
                var lineitem = TabManager.sharedInstance.currentTab.lines[i]
                if lineitem.beerOrWine == "Beer" {
                    // Calculate LineItem's Total Discount
                    let lineitemSavings = (lineitem.price) * 0.25
                    lineitem.savings = lineitemSavings
                    // Insert Discount Object After Discountable Item
                    discount25.quantity = lineitem.quantity
                    discount25.price = lineitem.savings
                    TabManager.sharedInstance.currentTab.lines.insert(discount25, atIndex: i+1)
                }
            }
            
            
        }
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
        var crvExpenses = Double()
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
            
            // Add CRV Amount to Total
            crvExpenses = lineitem.product.crvAmount * Double(lineitem.quantity)
            
            // Tax Calculations
            totalTax = totalTax + lineitem.tax // Already in dollars
        
            // Subtotal Calculations
            subtotal = subtotal + lineitem.price + allAdditionValuePrices // Already in dollars
            
        }
        // ----- END -----

        print("Total CRV Expenese: \(crvExpenses)")
        
        // Total Calculation
        let total = totalTax + subtotal + crvExpenses
        
        // Assignments
        currentTab.subtotal = subtotal
        currentTab.totalTax = totalTax
        currentTab.grandTotal = total
        
        if printFlag {
            print("---------------------------")
            print("Current Tab Totals Calculated: \(currentTab)")
            print("---------------------------")
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
    func placeOrder(view: UIViewController, tabController: UIViewController, tab: Tab) -> AnyObject {
        
        if printFlag {
            print("-----------------------")
            print("Tab For CloudCode Order: \(tab)")
            print("-----------------------")
        }
        
        // Separate Delivery and Take Away orders
        var deliveryOrders = [[String:AnyObject]]()
        var takeawayOrders = [[String:AnyObject]]()
        
        // Collection Storage For Build
        var modifiers = [[String:AnyObject]]()

        // BEGIN COLLECTING HERE
        for lineitem in TabManager.sharedInstance.currentTab.lines {


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
            
            // Guard Against Non-Subproducts
            var lineProductId: String
            var lineObjectId: String
            if lineitem.path == "Eat" {
                lineProductId = lineitem.subproduct.productId
                lineObjectId = lineitem.objectId
            } else if lineitem.path == "Drink" {
                lineProductId = lineitem.productId
                lineObjectId = lineitem.subproduct.objectId
            } else {
                lineProductId = lineitem.productId
                lineObjectId = lineitem.objectId
                
            }
            
            let paramLineItem : [String:AnyObject] = [
                "amount": lineitem.quantity,
                "objectId": lineObjectId,
                "modifiers": modifiers,
            ]
            
            // Lightspeed needs choice on same level as product being ordered
            let paramLineItemParent : [String:AnyObject] = [
                "objectId": lineitem.objectId,
                "amount": 1
            ]
            
            
            // Build And Layer Delivery and Take Away Arrays
            if lineitem.type == "delivery" {
                
                if lineitem.path == "Eat" {
                    deliveryOrders.append(paramLineItem)
                } else {
                    deliveryOrders.append(paramLineItemParent)
                    deliveryOrders.append(paramLineItem)
                }
                
            } else if lineitem.type == "takeaway" {
                
                if lineitem.path == "Eat" {
                    takeawayOrders.append(paramLineItem)
                } else {

                    takeawayOrders.append(paramLineItemParent)
                    takeawayOrders.append(paramLineItem)

                }
                
            } else {
                
                // Merch & Events Defaulted to Dine In (Delivery)
                deliveryOrders.append(paramLineItem)
            
            }
            
            
        }
        
//        // Guard Against Event's Type
//        if TabManager.sharedInstance.currentTab.type == "" {
//            TabManager.sharedInstance.currentTab.type = "delivery"
//        }
        
        // Build Delivery Order Object
        let deliveryBody : [String:AnyObject] = [
            "orderItems": deliveryOrders,
            "note": "Spoofer",
            "type": "delivery"
        ]
        // Build Delivery Param
        let deliveryParam : [String:AnyObject] = [
            "userId": tab.userId,
            "checkoutMethod": tab.checkoutMethod,
            "table": tab.table,
            "tipPercent": tab.gratuityPercent,

            "body": deliveryBody
        ] // --- END DELIVERY ORDER OBJECT BUILD ---
        
        
        // Build Take Away Order Object
        let takeawayBody : [String:AnyObject] = [
            "orderItems": takeawayOrders,
            "note": "Spoofer",
            "type": "takeaway"
        ]
        // Build Take Away Param
        let takeawayParam : [String:AnyObject] = [
            "checkoutMethod": tab.checkoutMethod,
            "table": tab.table,
            "tipPercent": tab.gratuityPercent,
            
            "body": takeawayBody
        ] // ----- END TAKEAWAY ORDER OBJECT BUILD -----
        
        
        // Create All Orders Object (Delivery and Take Away)
        var allOrders = [[String:AnyObject]]()
        
        if deliveryOrders.count > 0 {
            allOrders.append(deliveryParam)
        }
        if takeawayOrders.count > 0 {
            allOrders.append(takeawayParam)
        }
        
        
        // Create Order For CloudCode Function
        let order : [String:AnyObject] = [
            "userId": tab.userId,
            "orders": allOrders
        ]
        if printFlag {
            print("Order Equals: \(order)")
        }
        
        
        // Begin Placing Order with Order Object
        var result = String()
    
        ActivityManager.sharedInstance.activityStart(view)
        
        // Send Order Object To CloudCode
        PFCloud.callFunctionInBackground("placeOrders", withParameters: order ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            ActivityManager.sharedInstance.activityStop(view)

            
            if let error = error {
                
                // Failure 
                if printFlag {
                    print("Error: \(error)")
                }
                
                // Clean Up So Popover's Re-prompt 
                TabManager.sharedInstance.currentTab.checkoutMethod = ""
                TabManager.sharedInstance.currentTab.table = ""
                
                AlertManager.sharedInstance.placeOrderFailure(view, controller: tabController, title: "Whoops!", message: "Unable to place this order at this time. Please try again later.")
                
                
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
                
                AlertManager.sharedInstance.greatSuccessPreConfirm(view, title: "Great Success!", message: "Your order has been received. We'll notify you once it's been confirmed.")

                
                // Reset Segue Push Stack
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                //                appDelegate.resetToMenu()
                
            }
            
        }
        
        return result
        
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
            itemsIndicator.frame.origin.x = windowWidth - 74
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
    
    
    
    func getValidTableNumbers() {
        
        print("Collecting all valid table numbers... .. .")
        
        let tableNumberQuery:PFQuery = PFQuery(className: "Table")
        tableNumberQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("Table Number query has found \(objects!.count) valid table numbers.")
                print("---------------------")
                
                // Do something with the found objects.
                for object in objects! {
                    
                    self.validTableNumbers.append(object["name"] as! String)
//                    print("Table Number: \(object["name"] as! String) has been found valid.")
                    
                }
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
        
        
    }
    
    
    
    func getCRVObjects() {
        
        print("Collecting CRV Objects...")
        
        let crvQuery:PFQuery = PFQuery(className: "Product")
        crvQuery.whereKey("info", equalTo: "CRV")
        crvQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            print("CRV query has found \(objects!.count) CRV Parse objects.")
            
            if error == nil {
            // The find succeeded.

                
                // Do something with the found objects.
                for object in objects! {
                    
                    var newCRV = CRV()
                    newCRV.id = object["lightspeedId"] as! Int
                    newCRV.priceWithoutVat = object["priceWithoutVat"] as! Double
                        
                    self.crvObjects.append(newCRV)
                    
                }
                
                print("CRV query has created \(self.crvObjects.count) CRV structures.")
                print("---------------------")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }
    
    
    func getDiscountObjects() {
        
        print("Collecting Discount Objects...")
        
        let crvQuery:PFQuery = PFQuery(className: "Product")
        crvQuery.whereKey("productType", equalTo: "REDUCTIONONEPERCENTAGE")
        crvQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            print("Discount query has found \(objects!.count) Discount objects.")
            
            // The find succeeded.
            if error == nil {
                
                // Do something with the found objects.
                for object in objects! {
                    
                    var newDiscount = LineItem()
                    newDiscount.objectId = object.objectId!
                    newDiscount.discountAmount = object["priceWithoutVat"] as! Int
                    newDiscount.name = object["name"] as! String
                    newDiscount.discount = true
                    
                    self.discountObjects.append(newDiscount)
                    
                    if newDiscount.discountAmount == 15 {
                        self.discount15 = newDiscount
                    } else if newDiscount.discountAmount == 20 {
                        self.discount20 = newDiscount
                    } else if newDiscount.discountAmount == 25 {
                        self.discount25 = newDiscount
                    }
                    
                    
                }
                
                print("Discount query has created \(self.discountObjects.count) Discount structures.")
                print("---------------------")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }
    
}