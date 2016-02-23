//
//  SignupSceneOneTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4

@objc
protocol SignupSceneOneTableViewDelegate {
    func alternateLoginSignupNav()
    func showSignUpButton()
    func hideSignUpButton()
}

class SignupSceneOneTableViewController: UITableViewController, UITextFieldDelegate {
    
    var email = String()
    var password = String()
    
    var signupActive = true
    
    var delegate: SignupSceneOneTableViewDelegate?
    
    var SignupSceneOneViewControllerRef: SignUpViewController?
    
    var message = String()
    var buttonText = String()
    
    
    // ----------
    override func viewWillAppear(animated: Bool) {
        
        tableView.scrollEnabled = false
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

        tableView.backgroundColor = UIColor.blackColor()
        
        tableView.estimatedRowHeight = 50
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        message = "Already have an account?"
        buttonText = "Log In"


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Signup
    func saveUser(view: UIViewController, username: String, email: String, password: String) {
        AccountManager.sharedInstance.saveUser(view, username: username, email: email, password: password)
    }
    
    // Login
    func loginUser(view: UIViewController, username: String, email: String, password: String) {
        AccountManager.sharedInstance.loginUser(view, email: email, password: password)
    }
    
    func alternateTrigger(sender: AnyObject) {
        
        alternateSignupLogin()
        delegate?.alternateLoginSignupNav()
        
        self.tableView.reloadData()
        
    }
    
    func alternateSignupLogin() {
        
        // Login State
        if signupActive == true {
          
            message = "Don't have an account?"
            buttonText = "Sign Up"
            
            signupActive = false
            
        // Signup State
        } else {
            
            message = "Already registered?"
            buttonText = "Login"
            
            signupActive = true
            
        }
        
    }
    
    // MARK: - Text field data source
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.showSignUpButton()
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        // Email Row
        if indexPath.row == 0 {
            
            var inputCell: SignupInputTableViewCell
            inputCell = tableView.dequeueReusableCellWithIdentifier("SignupInputTableCell", forIndexPath: indexPath) as! SignupInputTableViewCell
            
            // Set Default Selection
            inputCell.inputTextField.becomeFirstResponder()
            
            // Show Sign Up Button
            textFieldDidEndEditing(inputCell.inputTextField)
            
            inputCell.inputLabel.text = "email"
            email = inputCell.inputTextField.text!
            
            inputCell.errorMessage.text = "Must be a valid email address."
            
            return inputCell
         
        // Password Row
        } else if indexPath.row == 1 {
            
            var inputCell: SignupInputTableViewCell
            inputCell = tableView.dequeueReusableCellWithIdentifier("SignupInputTableCell", forIndexPath: indexPath) as! SignupInputTableViewCell
            
            inputCell.inputTextField.secureTextEntry = true
            
            inputCell.inputLabel.text = "password"
            password = inputCell.inputTextField.text!
            
            inputCell.errorMessage.text = "Must be at least 8 characters long."
            
            return inputCell
            
        // Message Row
        } else if indexPath.row == 2 {
            
            var messageCell: SignupMessageTableViewCell
            messageCell = tableView.dequeueReusableCellWithIdentifier("SignupMessageTableCell", forIndexPath: indexPath) as! SignupMessageTableViewCell
            
            messageCell.alternateButton.addTarget(self, action: "alternateTrigger:", forControlEvents: .TouchUpInside)
            
            messageCell.message.text = message
            messageCell.alternateButton.setTitle(buttonText, forState: .Normal)
            
            return messageCell
            
        }


        return cell
        
    }


}
