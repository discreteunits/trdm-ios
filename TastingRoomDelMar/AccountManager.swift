//
//  AccountManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse



class AccountManager: NSObject {

    static let sharedInstance = AccountManager()
    
    // ----------
    
    override init() {
        super.init()
        
        // Initialize
        
    }
    
    // Facebook Signup and Login
    @available(iOS 8.0, *)
    func loginWithFacebook(view: UIViewController) {
        
//        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error: NSError?) -> Void in
//            
//            // Failure
//            if error != nil {
//                
//                AlertManager.sharedInstance.singleAlert(view, title: "Error", message: (error?.localizedDescription)!)
//                return
//                
//            // Success
//            } else if FBSDKAccessToken.currentAccessToken() != nil {
//                
//                if let user = user {
//                    
//                    // Doesn't Exist
//                    if user.isNew {
//                        
//                        AlertManager.sharedInstance.pushNotificationsAlert()
//                        
//                        view.performSegueWithIdentifier("fbsignin", sender: view)
//                        
//                        
//                        // Does Exist
//                    } else {
//                        
//                        dispatch_async(dispatch_get_main_queue()) {
//                            
//                            view.performSegueWithIdentifier("fblogin", sender: view)
//                            
//                        }
//                    }
//                }
//            }
//        })
    }
    
    // Save Parse User
    func saveUser(view: UIViewController, username: String, email: String, password: String) {
        
        ActivityManager.sharedInstance.activityStart(view)
        
        // Empty Strings
        if username == "" || password == "" {
            print("Did not trigger sign up")
            AlertManager.sharedInstance.singleAlert(view, title: "Whoops!", message: "Please enter an email and password.")
        
        // Continue
        } else {
            
            let user = PFUser()
        
            user.username = username
            user.email = email
            user.password = password
            
        
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
            
                ActivityManager.sharedInstance.activityStop(view)

                
                // Success
                if  error == nil {
                
                    if let user = PFUser.currentUser()  {
                        
                        if user.isNew {
                            
                            AlertManager.sharedInstance.pushNotificationsAlert()
                            
                        }
                        
                        print("Successfully saved user.")
                        view.performSegueWithIdentifier("signupContinue", sender: view)
                        
                    }
                    
                
                // Failure
                } else {
                
                    print("Failed to save user.")
                    AlertManager.sharedInstance.singleAlert(view, title: "Whoops!", message: "This account already exists, try logging in.")
                
                }
                
            })
            
        }
        
    }
    
    // Login Parse User
    func loginUser(view: UIViewController, email: String, password: String) {
        
        ActivityManager.sharedInstance.activityStart(view)
        
        PFUser.logInWithUsernameInBackground(email, password: password, block: { ( user, error ) -> Void in
            
            // Success
            if user != nil {
                
                print("Login Successful.")
                view.performSegueWithIdentifier("login", sender: view)
                
            // Failure
            } else {
                
                print("Login Failure")
                AlertManager.sharedInstance.singleAlert(view, title: "Whoops!", message: "Email and/or password is incorrect.")
                
            }
            
            ActivityManager.sharedInstance.activityStop(view)
            
        })
        
    }
    
    func addUserDetails(view: UIViewController, firstName: String, lastName: String, mobile: String, newsletter: Bool) {
 
        ActivityManager.sharedInstance.activityStart(view)
        
        let user = PFUser.currentUser()
        
        user!["firstName"] = firstName
        user!["lastName"] = lastName
        user!["mobileNumber"] = mobile
        
        if newsletter == true {
            user!["marketingAllowed"] = true
        } else {
            user!["marketingAllowed"] = false
        }
        
        
        user!.saveInBackgroundWithBlock { (success, error) -> Void in
            
            // Success 
            if error == nil {
             
                print("User has been updated successfully.")
                self.goToTiers(view)
                
            // Failure
            } else {
                
                print("Failed to update user")
                AlertManager.sharedInstance.singleAlert(view, title: "Whoops!", message: "Please try again later.")
                
            }
            
            ActivityManager.sharedInstance.activityStop(view)
            
        }
        
    }
    
    func goToTiers(view: UIViewController) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("Menu")
        
        view.presentViewController(vc, animated: true, completion: nil)
        
//        view.performSegueWithIdentifier("signin", sender: view)
        
    }
    
}
