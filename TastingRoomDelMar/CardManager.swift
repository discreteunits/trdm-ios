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
 
        currentCustomer.userId = (PFUser.currentUser()?.objectId!)!
        print("Current Customer: \(currentCustomer)")
        
    }
    
    
    // Set User Cards CLOUDCODE
    func setCard(userId: String, token: String) -> AnyObject {
        
        var result = String()

        PFCloud.callFunctionInBackground("createStripeCustomer", withParameters: ["userId": userId, "stripeToken": token] ) {
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

    
    
    // Get User Cards
    func getCards(id: String, user: PFUser) {
        
        let query:PFQuery = PFQuery(className: "Customer")
            query.includeKey("user")
            query.whereKey("objectId", equalTo: id)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The Find Succeeded
                print("\(objects!.count) cards found for this user.")
                
                for object in objects! as [PFObject]! {
                    
                    self.currentCustomer.cards.append(object)
                    
                }
                
            }
            
        }
        
    }
    
}
