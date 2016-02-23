//
//  AlertManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AlertManager: UIViewController {
    
    static let sharedInstance = AlertManager()
    
    // ---------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // ---------
    
    // Single Action Alert
    @available(iOS 8.0, *)
    func displayAlert(view: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
            print("User selected okay.")
            
        })
        
        alert.addAction(okAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Dual Action Alert
    
    // Triple Action Alert
    
    // Push Notifications Alert & Installation Assignment
    func pushNotificationsAlert() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            //  Swift 2.0
            if #available(iOS 8.0, *) {
                let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
                let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                UIApplication.sharedApplication().registerForRemoteNotifications()
            } else {
                let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
                UIApplication.sharedApplication().registerForRemoteNotificationTypes(types)
            }
            
            let installation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.addUniqueObject("customer", forKey: "channels")
            installation.saveInBackground()
            
        }
        
    }
    
    

}
