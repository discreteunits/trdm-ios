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
    
    var currentConfig = Config()
    
    // -------------
    override init() {
        super.init()
    }
    
    

}
