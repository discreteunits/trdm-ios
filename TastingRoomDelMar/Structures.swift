//
//  Structures.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/1/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

struct LineItem {
    var id = String()
    var cloverId = String()
    var quantity = Int()
    var price = Int()
    var tax = Int()
    var modifiers = [PFObject]()
    
}
