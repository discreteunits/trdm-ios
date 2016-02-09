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
        
        // Spoof CardManager Initilization
        var newCard = Card()
            newCard.id = "2w0r9u"
            newCard.provider = "Visa"
            newCard.number = "4242424242424242"
            newCard.expiration = "12/21"
            newCard.cvc = "034"
        
            newCard.lastFour = newCard.number.substringFromIndex(newCard.number.endIndex.advancedBy(-4))
        
        currentCustomer.userId = "342034"
        currentCustomer.cards.append(newCard)
        
        
        
//        currentCustomer.userId = (PFUser.currentUser()?.objectId!)!
        print("Current Customer: \(currentCustomer)")
        
    }
    

    
    
}
