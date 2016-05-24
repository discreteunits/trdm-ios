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
//    func activityStart(view: UIViewController) {
//        
//        activityIndicator.hidden = false
//        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
//        activityIndicator.center.y = view.view.center.y
//        activityIndicator.center.x = view.view.center.x
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
//        activityIndicator.startAnimating()
//        activityIndicator.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
//        activityIndicator.layer.cornerRadius = 8.0
//        activityIndicator.clipsToBounds = true
//        activityIndicator.tag = 901
//        
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//        
//        view.view.addSubview(activityIndicator)
//        
//    }
    
    
    // Stop Activity
//    func activityStop(view: UIViewController) {
//        
//        self.activityIndicator.stopAnimating()
//        
//        UIApplication.sharedApplication().endIgnoringInteractionEvents()
//        
//        if let viewWithTag = view.view.viewWithTag(901) {
//            viewWithTag.removeFromSuperview()
//        }
//    }
    
    
    // 1. i need to disable user interaction
    // 2. i need to present a popover view
    // 3. i need to cycle through an array of images
    // 4. i need to dismiss the popover view
    // 5. i need to enable user interaction
    
    
    
    // Start Activity
    func activityStart(view: UIViewController) {
        
        
        for subview in view.view.subviews {
            subview.hidden = true
        }
        
        view.view.userInteractionEnabled = false
        
        // Get Bounds
        let screenWidth = view.view.bounds.size.width
        
        let indicatorWindowView = UIView(frame:CGRectMake(0, 0, screenWidth * 0.5, screenWidth * 0.5))
        indicatorWindowView.frame.origin.y = screenWidth * 0.25
        indicatorWindowView.frame.origin.x = screenWidth * 0.25
        indicatorWindowView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        indicatorWindowView.layer.zPosition = 999999
        indicatorWindowView.clipsToBounds = true
        indicatorWindowView.layer.cornerRadius = 16.0
        indicatorWindowView.tag = 1336

        
        
        let trdmGifImage = UIImage.animatedImageNamed("spinner-", duration: 2.0)
        let trdmIndicatorImageView = UIImageView(image: trdmGifImage)
        trdmIndicatorImageView.frame = CGRectMake(0, 0,screenWidth * 0.15, screenWidth * 0.25)
        trdmIndicatorImageView.frame.origin.y = screenWidth * 0.55
        trdmIndicatorImageView.frame.origin.x = screenWidth * 0.425
        trdmIndicatorImageView.layer.zPosition = 9999999
        trdmIndicatorImageView.tag = 1337
        
        
//        view.view.addSubview(indicatorWindowView)
        view.view.addSubview(trdmIndicatorImageView)
        
        

        
        
        
    }
    
    // Stop Activity
    func activityStop(view: UIViewController) {
        
        for subview in view.view.subviews {
            subview.hidden = false
        }
        
        view.view.userInteractionEnabled = true
        
        if let viewWithTag = view.view.viewWithTag(1336) {
            viewWithTag.removeFromSuperview()
        }
        
        if let viewWithTag = view.view.viewWithTag(1337) {
            viewWithTag.removeFromSuperview()
        }
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
}
