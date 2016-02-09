//
//  Structures.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/1/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

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
    var cloverId = String()
    var state = String()
    var note = String()
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

struct Card {
    var id = String()
    var provider = String()
    var lastFour = String()
}

struct Customer {
    var userId = String()
    var stripeId = String()
    
    var cards = [Card]()
}

