//
//  SignupSceneOneViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4

class SignupSceneOneViewController: UIViewController {
    
    var SignupSceneOneTableViewControllerRef: SignupSceneOneTableViewController?
    
    var currentUser: PFUser?
    
    var nav: UINavigationBar?
    
    var signupButton = UIButton()
    
    var passedSignupOrLogin = String()
    
    // ----------
    override func viewWillAppear(animated: Bool) {

        dispatch_async(dispatch_get_main_queue()) {
            self.addSignupButton()
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set User
        if let user = PFUser.currentUser() {
            currentUser = user
        }
        
        // Nav Styles
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.topItem!.title = "Sign Up"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(20)]
            
            let backButton = UIBarButtonItem(title: "<", style: .Bordered, target: self, action: "back:")
            self.navigationItem.leftBarButtonItem = backButton
            
        }
        
        // Login Selected
        if passedSignupOrLogin == "login" {
            self.SignupSceneOneTableViewControllerRef?.alternateSignupLogin()
            alternateLoginSignupNav()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(sender: UIBarButtonItem) {
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func addSignupButton() {
        
        // Sign Up Button
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let keyboardHeight = self.SignupSceneOneTableViewControllerRef?.keyboard
        print("\(keyboardHeight)")
        let topOfKeyboard = (screenHeight - keyboardHeight!) - 130
        
        signupButton = UIButton(frame: CGRectMake(0, topOfKeyboard, screenWidth, 60))
        signupButton.setTitle("Continue", forState: .Normal)
        signupButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        signupButton.titleLabel?.font = UIFont.scriptFont(24)
        signupButton.addTarget(self, action: "signupAction:", forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.hidden = true
        
        self.view.addSubview(signupButton)
        
    }
    
    
    func signupAction(sender:UIButton!) {
        
        let email = self.SignupSceneOneTableViewControllerRef?.email
        let password = self.SignupSceneOneTableViewControllerRef?.password
        
        
        if self.SignupSceneOneTableViewControllerRef?.signupActive == true {
            
            self.SignupSceneOneTableViewControllerRef?.saveUser(self, username: email!, email: email!, password: password!)
            print("Signup action finished.")
            AlertManager.sharedInstance.pushNotificationsAlert()
            
        } else {
            
            self.SignupSceneOneTableViewControllerRef?.loginUser(self, username: email!, email: email!, password: password!)
            print("Login action finished.")
            AlertManager.sharedInstance.pushNotificationsAlert()
            
        }
        
        performSegueWithIdentifier("signupContinue", sender: self)
        
    }
    
    // Signup Button Animation
    func hideButtonVertical() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.signupButton.transform = CGAffineTransformIdentity
            self.signupButton.alpha = 0
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    self.signupButton.hidden = true
                    
                }
                
        }
        
    }
    
    func showButtonVertical() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.signupButton.transform = CGAffineTransformMakeTranslation(0, -self.signupButton.frame.height + 69)
            self.signupButton.alpha = 1
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    self.signupButton.hidden = false
                    
                }
                
        }
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "sceneOneEmbeded" {
            
            if let SignupSceneOneTableViewController = segue.destinationViewController as? SignupSceneOneTableViewController {
                
                self.SignupSceneOneTableViewControllerRef = SignupSceneOneTableViewController
                
                SignupSceneOneTableViewController.delegate = self
                
            }
            
        }
        
    }

}

extension SignupSceneOneViewController: SignupSceneOneTableViewDelegate {
    
    func alternateLoginSignupNav() {
        print("Alternated Signup / Login State.")
        var signupActive = self.SignupSceneOneTableViewControllerRef?.signupActive
        
        // Signup State
        if signupActive == true {
            
            nav = navigationController?.navigationBar
            nav?.topItem!.title = "Sign Up"
            self.signupButton.setTitle("Continue", forState: UIControlState.Normal)
            self.signupButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
            self.signupButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            signupActive = false
            
            // Login State
        } else {
            
            nav = navigationController?.navigationBar
            nav?.topItem!.title = "Login"
            self.signupButton.backgroundColor = UIColor.lightGrayColor()
            self.signupButton.setTitle("Login", forState: UIControlState.Normal)
            self.signupButton.layer.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor
            self.signupButton.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0), forState: UIControlState.Normal)
            signupActive = true
            
        }
        
    }
    
    func showSignUpButton() {
        showButtonVertical()
    }
    
    func hideSignUpButton() {
        hideButtonVertical()
    }

}
