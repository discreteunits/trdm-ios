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
    @IBOutlet weak var signUpButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpLoginTableViewControllerRef: SignUpLogInTableViewController?
    
    var currentUser: PFUser?
    
    var nav: UINavigationBar?
    
    let validator = Validator()
    

// ------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = PFUser.currentUser() {
            currentUser = user
        }
        
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.topItem!.title = "Sign Up"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]
            
        }
        
        
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("Validation successful style transformer")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            // validationRule.textField.layer.borderColor = UIColor.whiteColor().CGColor
            // validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                print("Validation failed style transformer")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                // validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                // validationError.textField.layer.borderWidth = 1.0
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// ----------------------
// LOGIN / SIGN UP
// ----------------------
    @IBAction func signup(sender: AnyObject) {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        if self.signUpLoginTableViewControllerRef?.signupActive == true {
            self.signUpLoginTableViewControllerRef?.saveUser()
            print("signup action finished")
        } else {
            self.signUpLoginTableViewControllerRef?.loginUser()
            print("login action finished")
        }

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
// Vertical UI Animation
// ----------------------

    func hideButtonVertical() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.signUpButton.transform = CGAffineTransformIdentity
            self.signUpButton.alpha = 0
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    self.signUpButton.hidden = true
                }
                
        }
        
    }
    
    func showButtonVertical() {
        
        self.signUpButton.hidden = false
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.signUpButton.transform = CGAffineTransformMakeTranslation(0, -self.signUpButton.frame.height)
            self.signUpButton.alpha = 1
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    
                }
                
        }
        
    }
    
// ----------------------
// SEMI-MAGICAL CONTROLLER DATA TRANSFER
// ----------------------
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
        print("alternateLoginSignupNav called from ViewController")
        var signupActive = self.signUpLoginTableViewControllerRef?.signupActive
        
        if signupActive == true {
            
            nav = navigationController?.navigationBar
            nav?.topItem!.title = "Sign Up"
            self.signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
            
        } else {
            
            nav = navigationController?.navigationBar
            nav?.topItem!.title = "Login"
            self.signUpButton.backgroundColor = UIColor.lightGrayColor()
            self.signUpButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
            
        }

    }
    
}
