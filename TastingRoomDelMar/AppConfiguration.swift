//
//  AppConfiguration.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 3/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AppConfiguration: NSObject {
    
    static let sharedInstance = AppConfiguration()
    
    
    private var _APP_ID = "kK30VZLdLwfWjOqOfzKbneFjniRGNKr3nOEb83kS"

    private var _CLIENT_ID = "BvU3xAcEB37sp3WXZUD9UhbpI4Set8CCUSbCa0OU"
    
    private var _STRIPE_ID = "pk_test_Ks6cqeQtnXJN0MQIkEOyAmKn"
    
    var databaseAppId: String {
        return _APP_ID
    }
    
    var databaseClientKey: String {
        return _CLIENT_ID
    }

    var paymentPublishableKey: String {
        return _STRIPE_ID
    }

    
    var primaryColor: UIColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
    
    var scriptFont: String {
        return "NexaRustScriptL-00"
    }

    var headerFont: String {
        return "BebasNeueRegular"
    }
    
    var basicFont: String {
        return "OpenSans"
    }
    
}
