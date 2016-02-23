//
//  AccountManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseCrashReporting
import ParseFacebookUtilsV4


class AccountManager: NSObject {

    static let sharedInstance = AccountManager()
    
    // ----------
    
    override init() {
        super.init()
        
        // Initialize
        
    }
    
    // FACEBOOK LOGIN
    @available(iOS 8.0, *)
    func loginWithFacebook(view: UIViewController) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error: NSError?) -> Void in
            
            // Failure
            if error != nil {
                AlertManager.sharedInstance.displayAlert(view, title: "Error", message: (error?.localizedDescription)!)
                return
                
                // Success
            } else if FBSDKAccessToken.currentAccessToken() != nil {
                
                if let user = user {
                    
                    // Doesn't Exist
                    if user.isNew {
                        
                        AlertManager.sharedInstance.pushNotificationsAlert()
                        
                        view.performSegueWithIdentifier("fbsignin", sender: view)
                        
                        
                        // Does Exist
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            view.performSegueWithIdentifier("fblogin", sender: view)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    // Save Parse User
    func saveUser(view: UIViewController, username: String, email: String, password: String) {
        
        let user = PFUser()
        
        user.username = username
        user.email = email
        user.password = password
        
        user.signUpInBackgroundWithBlock({ (success, error) -> Void in
            
            if  error == nil {
                
                print("Successfully saved user.")
                
            } else {
                
                print("Failed to save user.")
                AlertManager.sharedInstance.displayAlert(view, title: "Failure", message: "Please try again later.")
                
            }
            
        })
        
    }
    
    // LOGIN USER
    func loginUser(view: UIViewController, email: String, password: String) {
        
        PFUser.logInWithUsernameInBackground(email, password: password, block: { ( user, error ) -> Void in
            
            if user != nil {
                
                print("Login Successful.")
                //                self.performSegueWithIdentifier("login", sender: self)
                
            } else {
                
                print("Login Failure")
                
                AlertManager.sharedInstance.displayAlert(view, title: "Failure", message: "Please Try Again")
                
                
            }
            
        })
        
    }
    
    
    
}
