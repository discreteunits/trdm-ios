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

struct Modifier {
    var id = String()
    var cloverId = String()
    var name = String()
    var price = Double()
}

struct LineItem {
    var id = String()
    var cloverId = String()
    var name = String()
    var varietal = String()
    var quantity = Int()
    var price = Double()
    var tax = Double()
    var modifiers = [Modifier]()
}

struct Tab {
    var id = String()
    var note = String()
    var cloverId = String()
    var state = String()
    var table = String()
    var userId = String()
    var subtotal = Double()
    var totalTax = Double()
    var grandTotal = Double()
    
    var lines = [LineItem]()
    
    init() {
        if PFUser.currentUser() != nil {
            userId = PFUser.currentUser()!.objectId!
        }
    }
}

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