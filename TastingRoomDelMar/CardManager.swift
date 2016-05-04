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
        
        if printFlag {
            print("Current Customer: \(currentCustomer)")
        }
        
    }
    
    
    // Set User Cards CLOUDCODE
    func setCard(userId: String, token: String, view: UIViewController) -> AnyObject {
        
        ActivityManager.sharedInstance.activityStart(view)

        
        var result = String()

        PFCloud.callFunctionInBackground("addOrChangePaymentMethod", withParameters: ["userId": userId, "stripeToken": token] ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            ActivityManager.sharedInstance.activityStop(view)
            
            // Failure
            if let error = error {
                
                if printFlag {
                    print("\(error)")
                }

            // Success
            } else {
                
                result = String(response!)
                
                if printFlag {
                    print("Set Card Response: \(response!)")
                    print("Set Card Result: \(result)")
                }
                
                self.currentCustomer.objectId = String(response!)
                
                if printFlag {
                    print("Current Customer ID Set: \(self.currentCustomer.objectId)")
                }
                
                self.getCards()
                

            }
            
        }
        
        return result
        
    }
    
    // Get Card CLOUDCODE FUNCTION CALL FETCH
    func getCards() {
        
        
//        dispatch_async(dispatch_get_main_queue()){
        
            // Get User Card via User Object ID
            let card = CardManager.sharedInstance.fetchCards(TabManager.sharedInstance.currentTab.userId)
            CardManager.sharedInstance.currentCustomer.orderId.append(String(card))
            
//        }
        
        
    }
    
    // Fetch User Cards CLOUDCODE
    func fetchCards(userId: String) -> AnyObject {
        
        print("Attempting to fetch user card information...")
        
        var result = NSMutableDictionary()
        
        PFCloud.callFunctionInBackground("fetchCardForStripeCustomer", withParameters: ["userId": userId] ) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if let error = error {
                
                // Failure 
                if printFlag {
                    print("Error: \(error)")
                }
                
            } else {
                
                // Success
                result = response as! NSMutableDictionary
                
                if printFlag {
                    print("Response: \(response!)")
                    print("----------------------")
                }
                
                CardManager.sharedInstance.currentCustomer.card.brand = result["brand"] as! String
                CardManager.sharedInstance.currentCustomer.card.last4 = result["last4"] as! String
                
            }
        }
        
        return result
        
    }
}
