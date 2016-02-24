//
//  SignupSceneTwoViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SignupSceneTwoViewController: UIViewController {

    var nav: UINavigationBar?

    var signupButton = UIButton()

    var SignupSceneTwoTableViewControllerRef: SignupSceneTwoTableViewController?
    
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
//        let keyboardHeight = self.SignupSceneOneTableViewControllerRef?.keyboard
//        print("\(keyboardHeight)")
//        let topOfKeyboard = (screenHeight - keyboardHeight!) - 130
        
        let topOfKeyboard = screenHeight - 200
        
        signupButton = UIButton(frame: CGRectMake(0, topOfKeyboard, screenWidth, 60))
        signupButton.setTitle("Continue", forState: .Normal)
        signupButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        signupButton.titleLabel?.font = UIFont.scriptFont(24)
        signupButton.addTarget(self, action: "signupAction:", forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.hidden = true
        
        self.view.addSubview(signupButton)
        
    }
    
    func signupAction(sender:UIButton!) {
        // Make action for adding to current PFUser
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
    

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "sceneTwoEmbeded" {
            
            if let SignupSceneTwoTableViewController = segue.destinationViewController as? SignupSceneTwoTableViewController {
                
                self.SignupSceneTwoTableViewControllerRef = SignupSceneTwoTableViewController
                
                SignupSceneTwoTableViewController.delegate = self
                
            }
            
        }
        
    }


}

extension SignupSceneTwoViewController: SignupSceneTwoTableViewDelegate {
    
    func showSignUpButton() {
        showButtonVertical()
    }
    
    func hideSignUpButton() {
        hideButtonVertical()
    }
    
}
