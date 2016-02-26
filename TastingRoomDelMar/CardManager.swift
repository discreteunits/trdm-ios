//
//  CardManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CardManager: NSObject {
    
    static let sharedInstance = CardManager()
    
    var currentCustomer = Customer()
    
    // -----------------
    override init() {
        super.init()
 
        currentCustomer.userId = TabManager.sharedInstance.currentTab.userId
        print("Current Customer: \(currentCustomer)")
        
    }
    
    
    // Set User Cards CLOUDCODE
    func setCard(userId: String, token: String) -> AnyObject {
        
        var result = String()

        PFCloud.callFunctionInBackground("addOrChangePaymentMethod", withParameters: ["userId": userId, "stripeToken": token] ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                
                // Failure
                print("\(error)")
            } else {
                
                // Success
                result = String(response!)
                
                print("Response: \(response!)")
                print("Result: \(result)")
                
                self.currentCustomer.objectId = String(response!)
                print("Current Customer ID Set: \(self.currentCustomer.objectId)")
            }
            
        }
        
        return result
        
    }
    
    // Fetch User Cards CLOUDCODE
    func fetchCards(userId: String) -> AnyObject {
        
        var result = NSMutableDictionary()
        
        PFCloud.callFunctionInBackground("fetchCardForStripeCustomer", withParameters: ["userId": userId] ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                
                // Failure 
                print("Error: \(error)")
                
            } else {
                
                // Success
                result = response as! NSMutableDictionary
                print("Response: \(response!)")
                print("----------------------")
                
                CardManager.sharedInstance.currentCustomer.card.brand = result["brand"] as! String
                CardManager.sharedInstance.currentCustomer.card.last4 = result["last4"] as! String
                
            }
        
        }
        
        return result
        
    }
    
}
