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
    func activityStart(view: UIViewController) {
        
        activityIndicator.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = view.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
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
    
}
