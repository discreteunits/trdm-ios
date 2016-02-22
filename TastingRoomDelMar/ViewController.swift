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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signupOrLogin = String()

// ----------------
    override func viewWillAppear(animated: Bool) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        signupButton.layer.cornerRadius = 4.0
        signupButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 4.0
        loginButton.clipsToBounds = true
        fbLoginButton.layer.cornerRadius = 4.0
        fbLoginButton.clipsToBounds = true
        signupButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        loginButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        skipButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        
        // TRDM Logo Position
        let TRDMLogo = "secondary-logomark-white_rgb_600_600.png"
        let image = UIImage(named: TRDMLogo)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRectMake(0,0,screenWidth - 50, screenWidth - 50)
        imageView.frame.origin.y = screenHeight / 4
        imageView.frame.origin.x = 25
        
        self.view.addSubview(imageView)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginSelected(sender: AnyObject) {
        signupOrLogin = "login"
        performSegueWithIdentifier("startSignup", sender: self)
    }
    
    // FACEBOOK LOGIN
    @available(iOS 8.0, *)
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        activityStart()
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error: NSError?) -> Void in
            
            if(error != nil) {
                self.displayAlert("Error", message: (error?.localizedDescription)!)
                return
            } else if FBSDKAccessToken.currentAccessToken() != nil {
                
                // If User is new
                if let user = user {
                    if user.isNew {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                        
                            //  Swift 2.0
                            if #available(iOS 8.0, *) {
                                let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
                                let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
                                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                                UIApplication.sharedApplication().registerForRemoteNotifications()
                                
                                self.setUserPointOnInstallation()
                                
                                
                            } else {
                                let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
                                UIApplication.sharedApplication().registerForRemoteNotificationTypes(types)
                                
                                self.setUserPointOnInstallation()
                                
                            }

                            self.performSegueWithIdentifier("fbsignin", sender: self)
                        
                        }
                        
                        self.activityStop()
                        
                    // If User already exists
                    } else {
                        
                        self.activityStop()
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.performSegueWithIdentifier("fblogin", sender: self)
                            self.activityStop()

                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    // Set User To Installation
    func setUserPointOnInstallation() {
        
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.addUniqueObject("customer", forKey: "channels")
        installation.saveInBackground()
        
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
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "startSignup" {
            
            // Prepare for segue through navigation controller
            let destinationNC = segue.destinationViewController as! UINavigationController
            let targetController = destinationNC.topViewController as! SignUpViewController
            targetController.passedSignupOrLogin = signupOrLogin

        }
        
    }
    
}
