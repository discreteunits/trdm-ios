//
//  ActivityManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class ActivityManager: NSObject {
    
    static let sharedInstance = ActivityManager()
    
    // ----------
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override init() {
        super.init()
        
        // Initialize
        
    }
    
    // Start Activity
    func activityStart(view: UIView) {
        
        activityIndicator.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        view.addSubview(activityIndicator)
        
    }
    
    // Stop Activity
    func activityStop() {
        
        self.activityIndicator.stopAnimating()
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    
}
