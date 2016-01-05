//
//  ViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4

class ViewController: UIViewController {

    var signupActive = true
    
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var registeredText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
// ----------------------
// ALERT FUNCTION
// ----------------------
    
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            print("Ok")
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// ----------------------
// ACTIVITY START FUNCTION
// ----------------------
    
    func activityStart() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
// ----------------------
// ACTIVITY STOP FUNCTION
// ----------------------
    func activityStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
     
// ----------------
// FACEBOOK LOGIN
// ----------------
    
    @available(iOS 8.0, *)
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error: NSError?) -> Void in
            
            if(error != nil) {
                self.displayAlert("Error", message: (error?.localizedDescription)!)
                return
            } else {
                
                self.activityStart()
                
                if let user = user {
                    if user.isNew {
                        
                        self.activityStop()
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.performSegueWithIdentifier("signup", sender: self)
                            
                        }
                    } else {
                        
                        self.activityStop()
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.performSegueWithIdentifier("login", sender: self)
                            
                        }
                    }
                }
            }
        })
    }
    
    
// ------------------
// ALTERNATE LOGIN AND SIGN UP
// ------------------
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            signupButton.setTitle("Log in with Whomi", forState: UIControlState.Normal)
            registeredText.text = "Not Registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            fbLoginButton.setTitle("Log in with Facebook", forState: UIControlState.Normal)
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign up with Whomi", forState: UIControlState.Normal)
            registeredText.text = "Already Registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            fbLoginButton.setTitle("Sign up with Facebook", forState: UIControlState.Normal)
            signupActive = true
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.signupButton.layer.cornerRadius = 5
        //        self.loginButton.layer.cornerRadius = 5
        //        self.fbLoginButton.layer.cornerRadius = 5
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
