//
//  ActivityManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

class ActivityManager: NSObject {
    
    static let sharedInstance = ActivityManager()
    
    // ----------

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    

    override init() {
        super.init()
        
        // Initialize
        
    }
    
    // Start Activity
    func activityStart(view: UIViewController) {
        
        activityIndicator.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center.y = view.view.center.y
        activityIndicator.center.x = view.view.center.x
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        activityIndicator.layer.cornerRadius = 8.0
        activityIndicator.clipsToBounds = true
        activityIndicator.tag = 901
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        view.view.addSubview(activityIndicator)
        
    }
    
    
    // Stop Activity
    func activityStop(view: UIViewController) {
        
        self.activityIndicator.stopAnimating()
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        if let viewWithTag = view.view.viewWithTag(901) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    // 1. i need to disable user interaction
    // 2. i need to present a popover view
    // 3. i need to cycle through an array of images
    // 4. i need to dismiss the popover view
    // 5. i need to enable user interaction
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
