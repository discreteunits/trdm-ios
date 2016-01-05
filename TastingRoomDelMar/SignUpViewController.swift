//
//  SignUpViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4

class SignUpViewController: UIViewController {

    
    override func viewDidAppear(animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]


    }
    
    
// ----------------------
// TRDM SIGNUP FUNCTION
// ----------------------
//
//    @available(iOS 8.0, *)
//    @IBAction func signup(sender: AnyObject) {
//        
//        if username.text == "" || password.text == "" {
//            
//            displayAlert("Error", message: "Invalid username or password")
//            
//        } else {
//            
//            activityStart()
//            
//            var errorMessage = "Please try again later."
//            
//            if signupActive == true {
//                
//                var user = PFUser()
//                user.username = username.text
//                user.password = password.text
//                
//                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
//                    
//                    self.activityStop()
//                    
//                    if error == nil {
//                        
//                        // Signup Successful
//                        self.performSegueWithIdentifier("signup", sender: self)
//                        
//                    } else {
//                        
//                        // Signup Failure
//                        if let errorString = error!.userInfo["error"] as? String {
//                            errorMessage = errorString
//                        }
//                        
//                        self.displayAlert("Failed Signup", message: errorMessage)
//                        
//                    }
//                })
//                
//            } else {
//                
//                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { ( user, error ) -> Void in
//                    
//                    self.activityStop()
//                    
//                    if user != nil {
//                        
//                        // Logged In!
//                        self.performSegueWithIdentifier("login", sender: self)
//                        
//                    } else {
//                        
//                        // Login Failure
//                        if let errorString = error!.userInfo["error"] as? String {
//                            errorMessage = errorString
//                        }
//                        
//                        self.displayAlert("Failed Login", message: errorMessage)
//                    }
//                })
//            }
//        }
//    }
//
//    
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
