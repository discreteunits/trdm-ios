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
import SwiftValidator


class SignUpViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpLoginTableViewControllerRef: SignUpLogInTableViewController?
    
    var currentUser: PFUser?
    
    var nav: UINavigationBar?
    
    let validator = Validator()
    
    var sign = UIButton()
    
    var passedSignupOrLogin = String()
    

// ------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set User
        if let user = PFUser.currentUser() {
            currentUser = user
        }
        
        // Navf Styles
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            
            nav?.topItem!.title = "Sign Up"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 20)!]
            
        }

//        validator.styleTransformers(success:{ (validationRule) -> Void in
//            print("Validation successful style transformer")
//            // clear error label
//            validationRule.errorLabel?.hidden = true
//            validationRule.errorLabel?.text = ""
//            // validationRule.textField.layer.borderColor = UIColor.whiteColor().CGColor
//            // validationRule.textField.layer.borderWidth = 0.5
//            
//            }, error:{ (validationError) -> Void in
//                print("Validation failed style transformer")
//                validationError.errorLabel?.hidden = false
//                validationError.errorLabel?.text = validationError.errorMessage
//                // validationError.textField.layer.borderColor = UIColor.redColor().CGColor
//                // validationError.textField.layer.borderWidth = 1.0
//        })
        
        
        // Decide if User selected Signup or Login from landing view
        if passedSignupOrLogin == "login" {
            self.signUpLoginTableViewControllerRef?.alternateLoginSignup()
            alternateLoginSignupNav()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Sign Up Button
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let topOfKeyboard = screenHeight - 345

        
        sign = UIButton(frame: CGRectMake(0, topOfKeyboard, screenWidth, 60))
        sign.setTitle("Sign Up", forState: .Normal)
        sign.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
        sign.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 24)
        sign.addTarget(self, action: "signupAction:", forControlEvents: UIControlEvents.TouchUpInside)
        sign.hidden = true
        
        self.view.addSubview(sign)

        
//        let keyboardConstraint = NSLayoutConstraint(item: signUpButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: topOfKeyboard)
        
        
//        self.signUpButton.frame = CGRectMake(0, 0, screenWidth, 60)

        
    }
    
    // For Programmatically Added Signup Button
    func signupAction(sender:UIButton!) {
        
        activityStart()
        
        if self.signUpLoginTableViewControllerRef?.signupActive == true {
            
            self.signUpLoginTableViewControllerRef?.saveUser()
            print("signup action finished")
            notificationAlert()
            
        } else {
            
            self.signUpLoginTableViewControllerRef?.loginUser()
            print("login action finished")
            notificationAlert()
            
        }
        
        performSegueWithIdentifier("signup", sender: self)
        activityStop()
    }
    
    func notificationAlert() {
        
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
    
    // ALERT FUNCTION
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            print("Ok")
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // ACTIVITY START FUNCTION
    func activityStart() {
        activityIndicator.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        view.addSubview(activityIndicator)
    }
    
    // ACTIVITY STOP FUNCTION
    func activityStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    // Vertical UI Animation
    func hideButtonVertical() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.sign.transform = CGAffineTransformIdentity
            self.sign.alpha = 0
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    self.sign.hidden = true

                }
                
        }
        
    }
    
    func showButtonVertical() {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.sign.transform = CGAffineTransformMakeTranslation(0, -self.sign.frame.height + 69)
            self.sign.alpha = 1
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    self.sign.hidden = false
                    
                }
                
        }
        
    }
    
// SEMI-MAGICAL CONTROLLER DATA TRANSFER
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SignUpLoginEmbeded" {
            
            if let SignUpLogInTableViewController = segue.destinationViewController as? SignUpLogInTableViewController {
                
                self.signUpLoginTableViewControllerRef = SignUpLogInTableViewController
                
                SignUpLogInTableViewController.containerViewController = self // check if needed
                
                SignUpLogInTableViewController.delegate = self
                
            }
        }
    }

}

extension SignUpViewController: SignUpLogInTableViewDelegate {
    func showSignUpButton() {
        print("called showSignUpButton from SignUpLogInViewDelegate")
        showButtonVertical()
    }
    func hideSignUpButton() {
        print("called hideSignUpButton from SignUpLogInViewDelegate")
        hideButtonVertical()
    }
    func alternateLoginSignupNav() {
        print("Alternated Signup / Login State.")
        var signupActive = self.signUpLoginTableViewControllerRef?.signupActive
        
        // Signup State
        if signupActive == true {
            
            nav = navigationController?.navigationBar
            nav?.topItem!.title = "Sign Up"
            self.sign.setTitle("Sign Up", forState: UIControlState.Normal)
            self.sign.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
            self.sign.setTitleColor(UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), forState: UIControlState.Normal)
            
            signupActive = false
            
        // Login State
        } else {
            
            nav = navigationController?.navigationBar
            nav?.topItem!.title = "Login"
            self.sign.backgroundColor = UIColor.lightGrayColor()
            self.sign.setTitle("Login", forState: UIControlState.Normal)
            self.sign.layer.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor
            self.sign.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0), forState: UIControlState.Normal)
            signupActive = true
            
        }

    }
    
}


