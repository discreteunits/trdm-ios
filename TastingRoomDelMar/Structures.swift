//
//  Structures.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/1/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import Stripe

// Tab Manager
struct SubProduct {
    var id = String()
    var lightspeedId = String()
    var name = String()
    var price = Double()
}

struct Addition {
    var id = String()
    var lightspeedId = String()
    var name = String()
    var price = Double()
}

struct LineItem {
    var id = String()
    var lightspeedId = String()
    var name = String()
    var varietal = String()
    var quantity = Int()
    var price = Double()
    var tax = Double()
    var subproducts = [SubProduct]()
}

struct Tab {
    var id = String()
    var note = String()
    var lightspeedId = String()
    var state = String()
    var table = String()
    var userId = String()
    var subtotal = Double()
    var totalTax = Double()
    var grandTotal = Double()
    var checkoutMethod = String()
    var gratuity = Double()
    
    var lines = [LineItem]()
    
    init() {
        if PFUser.currentUser()!.objectId != nil {
            userId = PFUser.currentUser()!.objectId!
        }
    }
}

// Card Manager
struct Customer {
    var objectId = String()
    var userId = String()
    var stripeId = String()
    var orderId = [String]()
    
    var card = Card()
}

struct Card {
    var brand = String()
    var last4 = String()
}

public struct Validator {
    public static func isEmailValid(var email:String) -> Bool {
       
        if email.rangeOfString("@") != nil {
            return true
        } else {
            return false
        }
        
    }
}

