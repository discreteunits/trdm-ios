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
}

struct LineItem {
    var id = String()
    var cloverId = String()
    var quantity = Int()
    var price = Int()
    var tax = Int()
    var modifiers = [Modifier]()
}


struct Tab {
    var id = String()
    var cloverId = String()
    var note = String()
    var table = String()
    var userId = String()
    var subtotal = Int()
    var totalTax = Int()
    var grandTotal = Int()
    
    var lines = [LineItem]()
    
    init() {
        if PFUser.currentUser() != nil {
            userId = PFUser.currentUser()!.objectId!
        }
    }
}