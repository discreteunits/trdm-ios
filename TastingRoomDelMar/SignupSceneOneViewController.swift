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
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
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
            
            let backButton = UIBarButtonItem(title: "<", style: .Plain, target: self, action: #selector(SignupSceneOneViewController.back(_:)))
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
        let screenSize = self.view.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let keyboardHeight = self.SignupSceneOneTableViewControllerRef?.keyboard
        print("\(keyboardHeight)")
        let topOfKeyboard = (screenHeight - keyboardHeight!) - 68
        
        signupButton = UIButton(frame: CGRectMake(0, topOfKeyboard, screenWidth, 60))
        signupButton.setTitle("Continue", forState: .Normal)
        signupButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        signupButton.titleLabel?.font = UIFont.scriptFont(24)
        signupButton.addTarget(self, action: #selector(SignupSceneOneViewController.signupAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.hidden = true
        
        self.view.addSubview(signupButton)
        
    }
    
    
    func signupAction(sender:UIButton!) {
        
        // Sign Up
        if self.SignupSceneOneTableViewControllerRef?.signupActive == true {
            
            self.SignupSceneOneTableViewControllerRef?.saveUser(self)
            AlertManager.sharedInstance.pushNotificationsAlert()
          
        // Log In
        } else {
            
            self.SignupSceneOneTableViewControllerRef?.loginUser(self)
            AlertManager.sharedInstance.pushNotificationsAlert()
            
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
        if printFlag {
            print("Alternated Signup / Login State.")
        }
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
        AnimationManager.sharedInstance.showButtonVertical(self, button: signupButton)
    }
    
    func hideSignUpButton() {
        AnimationManager.sharedInstance.hideButtonVertical(self, button: signupButton)
    }

}
