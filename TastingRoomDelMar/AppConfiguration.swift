//
//  AppConfiguration.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 3/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


class AppConfiguration: NSObject {
    
    static let sharedInstance = AppConfiguration()
    
    
//    private var _APP_ID = "kK30VZLdLwfWjOqOfzKbneFjniRGNKr3nOEb83kS"
//
//    private var _CLIENT_ID = "BvU3xAcEB37sp3WXZUD9UhbpI4Set8CCUSbCa0OU"
    
    private var _APP_ID = "ec321db54f541c125465ddc586b54b08"
    private var _CLIENT_ID = " "
    private var _SERVER_URL = "https://trdm-production-717.nodechef.com/parse"
    
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

    // Strings for branding content ie: a convention for images ie: brand-logo.png
    // primary brand image
    // primary brand image with tag line
    // primary brand icon
    // secondary branding image
    // secondary branding image with tag line
    // secondary branding icon 
    
    
    var primaryColor: UIColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
    // secondaryColor
    
    
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
