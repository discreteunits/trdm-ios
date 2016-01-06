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
import Alamofire


class SignUpViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpLoginTableViewControllerRef: SignUpLogInTableViewController?
    
    var currentUser: PFUser? {
        didSet {
            if currentUser!.email == NSNull() {
                self.getUserData()
            }
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]

    }
    
    
// ----------------------
// SIGNUP FUNCTION
// ----------------------
    @IBAction func signup(sender: AnyObject) {
        print("signup action fired")
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        self.signUpLoginTableViewControllerRef?.saveUser()
    }
    
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
    
// ----------------------
// Horizontal UI Animation
// ----------------------
    func hideButton() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.signUpButton.transform = CGAffineTransformIdentity
            
            
            }, completion: nil)
        
    }
    
    func showButton() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.signUpButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
            
            }, completion: nil)
        
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

extension SignUpViewController: SignUpLogInTableViewDelegate {
    

    
}
