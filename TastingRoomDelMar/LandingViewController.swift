//
//  LandingViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4
import ReachabilitySwift


<<<<<<< HEAD
class LandingViewController: UIViewController, ENSideMenuDelegate {
=======
class LandingViewController: UIViewController {
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
    
    var screenSize = CGRect()
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var signupActive = true
    
    var signupOrLogin = String()
<<<<<<< HEAD
    
=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd

    // ------------
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewWillAppear(animated: Bool) {
        
        RouteManager.sharedInstance.resetRoute()
        TabManager.sharedInstance.currentTab.lines.removeAll()        
        
        print("Print Statements Have Been Set To: \(printFlag)")
        if printFlag {
            print("Created By: Tobias Brysiewicz")
        }
        print("------------------------------------------")

        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        self.view.backgroundColor = UIColor.blackColor()
        
        trdmLogo()
        buttons()
        
<<<<<<< HEAD

=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func trdmLogo() {
        
        // TRDM Logo
        let TRDMLogo = "secondary-logomark-white_rgb_600_600.png"
        let image = UIImage(named: TRDMLogo)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRectMake(0,0,screenWidth - 50, screenWidth - 50)
        imageView.frame.origin.y = screenHeight / 4
        imageView.frame.origin.x = 25
        
        self.view.addSubview(imageView)
        
    }
    
    func buttons() {
        
        // Skip Button
        let skipButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.2, 30))
        skipButton.frame.origin.x = screenWidth * 0.75
        skipButton.frame.origin.y = screenHeight * 0.05
        skipButton.setTitle("skip", forState: .Normal)
        skipButton.titleLabel?.font = UIFont.scriptFont(18)
        skipButton.titleLabel?.textColor = UIColor.whiteColor()
        skipButton.layer.backgroundColor = UIColor.clearColor().CGColor
        skipButton.layer.cornerRadius = 4.0
        skipButton.clipsToBounds = true
        skipButton.addTarget(self, action: #selector(LandingViewController.guest), forControlEvents: UIControlEvents.TouchUpInside)
        skipButton.hidden = true
        skipButton.tag = 77
        
        self.view.addSubview(skipButton)
        
        // Signup Button
<<<<<<< HEAD
        let signupButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.4, screenHeight * 0.06))
=======
        let signupButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.4, 40))
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        signupButton.frame.origin.x = screenWidth * 0.075
        signupButton.frame.origin.y = screenHeight * 0.8
        signupButton.setTitle("Sign Up", forState: .Normal)
        signupButton.titleLabel?.font = UIFont.scriptFont(18)
        signupButton.titleLabel?.textColor = UIColor.whiteColor()
        signupButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).CGColor
        signupButton.layer.cornerRadius = 4.0
        signupButton.clipsToBounds = true
        signupButton.addTarget(self, action: #selector(LandingViewController.signin), forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.hidden = true
        signupButton.tag = 78
        
        self.view.addSubview(signupButton)
        
        // Login Button
<<<<<<< HEAD
        let loginButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.4, screenHeight * 0.06))
=======
        let loginButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.4, 40))
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        loginButton.frame.origin.x = screenWidth * 0.525
        loginButton.frame.origin.y = screenHeight * 0.8
        loginButton.setTitle("Log In", forState: .Normal)
        loginButton.titleLabel?.font = UIFont.scriptFont(18)
        loginButton.titleLabel?.textColor = UIColor.whiteColor()
        loginButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).CGColor
        loginButton.layer.cornerRadius = 4.0
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(LandingViewController.login), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.hidden = true
        loginButton.tag = 79
        
        self.view.addSubview(loginButton)
        
        // Facebook Button
<<<<<<< HEAD
        let facebookButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.85, screenHeight * 0.06))
=======
        let facebookButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.85, 40))
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        facebookButton.frame.origin.x = screenWidth * 0.075
        facebookButton.frame.origin.y = screenHeight * 0.875
        facebookButton.setTitle("Log in with Facebook", forState: .Normal)
        facebookButton.titleLabel?.font = UIFont.basicFont(18)
        facebookButton.titleLabel?.textColor = UIColor.whiteColor()
        facebookButton.layer.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0).CGColor
        facebookButton.layer.cornerRadius = 4.0
        facebookButton.clipsToBounds = true
        facebookButton.addTarget(self, action: #selector(LandingViewController.facebook), forControlEvents: UIControlEvents.TouchUpInside)
        facebookButton.hidden = true
        facebookButton.tag = 80
        
        self.view.addSubview(facebookButton)
        
        // Not Connected Message
        let disconnectedMessage = UITextView(frame: CGRectMake(0, 0, screenWidth * 0.875, 80))
        disconnectedMessage.frame.origin.x = screenWidth * 0.125
        disconnectedMessage.frame.origin.y = screenHeight * 0.78
        disconnectedMessage.text = "You must be connected to the internet to use this app."
        disconnectedMessage.textAlignment = .Center
        disconnectedMessage.font = UIFont.headerFont(28)
        disconnectedMessage.textColor = UIColor.whiteColor()
        disconnectedMessage.backgroundColor = UIColor.lightGrayColor()
        disconnectedMessage.layer.cornerRadius = 4.0
        disconnectedMessage.clipsToBounds = true
        disconnectedMessage.hidden = true
        disconnectedMessage.scrollEnabled = false
        disconnectedMessage.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        disconnectedMessage.contentInset = UIEdgeInsets(top: 8,left: 8, bottom: 8,right: 8)
        disconnectedMessage.textContainer.maximumNumberOfLines = 0
        disconnectedMessage.sizeToFit()
        disconnectedMessage.alpha = 0.8
        
        self.view.addSubview(disconnectedMessage)
        
        checkConnectivity(skipButton, signin: signupButton, login: loginButton, facebook: facebookButton, disconnected: disconnectedMessage)
        
    }
    
    func facebook() {
        AccountManager.sharedInstance.loginWithFacebook(self)
    }
    
    func signin() {
        performSegueWithIdentifier("startSignup", sender: self)
    }
    
    func login() {
        signupOrLogin = "login"
        performSegueWithIdentifier("startSignup", sender: self)
    }
    
    func guest() {
        performSegueWithIdentifier("guest", sender: self)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "startSignup" {
            
            // Prepare for segue through navigation controller
            let destinationNC = segue.destinationViewController as! UINavigationController
            let targetController = destinationNC.topViewController as! SignupSceneOneViewController
            targetController.passedSignupOrLogin = signupOrLogin
            
        }
        
    }
    
    func checkConnectivity(skip: UIButton, signin: UIButton, login: UIButton, facebook: UIButton, disconnected: UITextView) {
        
        // CONNECTIVITY CONTROL
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            print("Device can be Reached.")
        } catch {
            print("Device can not be Reached.")
            return
        }
        
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    
                    skip.hidden = false
                    signin.hidden = false
                    login.hidden = false
                    facebook.hidden = false
                    
                    disconnected.hidden = true
                    
                    print("Reachable via WiFi")
                } else {
                    
                    skip.hidden = false
                    signin.hidden = false
                    login.hidden = false
                    facebook.hidden = false
                    
                    disconnected.hidden = true
                    
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                
                skip.hidden = true
                signin.hidden = true
                login.hidden = true
                facebook.hidden = true
                
                disconnected.hidden = false
                
                print("No internet connection... removing app access points.")
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
