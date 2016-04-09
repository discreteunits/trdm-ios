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

class LandingViewController: UIViewController {
    
    var screenSize = CGRect()
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var signupActive = true
    
    var signupOrLogin = String()

    // ------------
    override func viewWillAppear(animated: Bool) {
        
        route.removeAll()
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        self.view.addSubview(skipButton)
        
        // Signup Button
        let signupButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.4, 40))
        signupButton.frame.origin.x = screenWidth * 0.075
        signupButton.frame.origin.y = screenHeight * 0.8
        signupButton.setTitle("Sign Up", forState: .Normal)
        signupButton.titleLabel?.font = UIFont.scriptFont(18)
        signupButton.titleLabel?.textColor = UIColor.whiteColor()
        signupButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).CGColor
        signupButton.layer.cornerRadius = 4.0
        signupButton.clipsToBounds = true
        signupButton.addTarget(self, action: #selector(LandingViewController.signin), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(signupButton)
        
        // Login Button
        let loginButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.4, 40))
        loginButton.frame.origin.x = screenWidth * 0.525
        loginButton.frame.origin.y = screenHeight * 0.8
        loginButton.setTitle("Log In", forState: .Normal)
        loginButton.titleLabel?.font = UIFont.scriptFont(18)
        loginButton.titleLabel?.textColor = UIColor.whiteColor()
        loginButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).CGColor
        loginButton.layer.cornerRadius = 4.0
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(LandingViewController.login), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(loginButton)
        
        // Facebook Button
        let facebookButton = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.85, 40))
        facebookButton.frame.origin.x = screenWidth * 0.075
        facebookButton.frame.origin.y = screenHeight * 0.875
        facebookButton.setTitle("Log in with Facebook", forState: .Normal)
        facebookButton.titleLabel?.font = UIFont.basicFont(18)
        facebookButton.titleLabel?.textColor = UIColor.whiteColor()
        facebookButton.layer.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0).CGColor
        facebookButton.layer.cornerRadius = 4.0
        facebookButton.clipsToBounds = true
        facebookButton.addTarget(self, action: #selector(LandingViewController.facebook), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(facebookButton)
        
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

}
