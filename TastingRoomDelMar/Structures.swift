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

// App Configuration
struct Config {
    
    var databaseAppId = "kK30VZLdLwfWjOqOfzKbneFjniRGNKr3nOEb83kS"
    var databaseClientKey = "BvU3xAcEB37sp3WXZUD9UhbpI4Set8CCUSbCa0OU"
    
    var paymentKey = "pk_test_Ks6cqeQtnXJN0MQIkEOyAmKn"
    
    var companyName = "Tasting Room Del Mar"
    var companyAddress = "1435 Camino Del Mar Del Mar, CA, 92014"
    var companyPhone = "858.232.6545"
    var companyTagline = String()
    
    var brandColor = String()
    var primaryColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
    var secondaryColor = String()
    
    var scriptFont = "NexaRustScriptL-00"
    var headerFont = "BebasNeueRegular"
    var basicFont = "OpenSans"
    
    struct faceBook {
        var secret = String()
        var key = String()
    }
    
    struct twitter {
        var secret = String()
        var key = String()
    }
    
}

// Tab Manager
struct Modifier {
    var lightspeedId = String()
    var modifierValueId = String()
    var info = String()
    var name = String()
    var price = String()
    
}

struct ModifierGroup {
    var lightspeedId = String()
    var name = String()
    var price = Double()
    var modifiers = [Modifier]()
}

struct Product {
    var id = String()
    var lightspeedId = String()
    var name = String()
    var price = Double()
    
    var productPlu = String()
    
    var modifiergroups = [ModifierGroup]()
    
}

struct LineItem {
    var id = String()
    var lightspeedId = String()
    var name = String()
    var varietal = String()
    var quantity = Int()
    var price = Double()
    var tax = Double()
    var product = Product()
    var subproducts = [Product]()
}

struct Tab {
    var id = String()
    var type = String()
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

