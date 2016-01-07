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
    
    var currentUser: PFUser?
    
// ------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = PFUser.currentUser() {
            currentUser = user
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]

    }
    
// ----------------------
// SEMI-MAGICAL CONTROLLER DATA TRANSFER
// ----------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SignUpLoginEmbeded" {
            
            if let SignUpLogInTableViewController = segue.destinationViewController as? SignUpLogInTableViewController {
                
                self.signUpLoginTableViewControllerRef = SignUpLogInTableViewController
                
                SignUpLogInTableViewController.containerViewController = self
                
            }
        }
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
    

    
    

}


