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

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var accountMessage: UILabel!
    @IBOutlet weak var alternateButton: UIButton!
    
    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var emailCheckmark: UIImageView!
    
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var passwordCheckmark: UIImageView!
    
    
    var signupActive = true
    
    var delegate: SignupSceneOneTableViewDelegate?
    
    var SignupSceneOneViewControllerRef: SignUpViewController?
    
    // ----------
    override func viewWillAppear(animated: Bool) {
        
        emailCheckmark.hidden = true
        passwordCheckmark.hidden = true
        
        emailErrorMessage.hidden = true
        passwordErrorMessage.hidden = true
        
        emailTextField.becomeFirstResponder()
        
        tableView.scrollEnabled = false
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

        tableView.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.font = UIFont.headerFont(16)
        emailLabel.textColor = UIColor.whiteColor()
        
        emailTextField.font = UIFont.headerFont(16)
        emailTextField.textColor = UIColor.whiteColor()
        
        emailErrorMessage.font = UIFont.basicFont(10)
        emailErrorMessage.textColor = UIColor.redColor()
        
        passwordLabel.font = UIFont.headerFont(16)
        passwordLabel.textColor = UIColor.whiteColor()

        passwordTextField.font = UIFont.headerFont(16)
        passwordTextField.textColor = UIColor.whiteColor()
        
        passwordErrorMessage.font = UIFont.basicFont(10)
        passwordErrorMessage.textColor = UIColor.redColor()
        
        accountMessage.font = UIFont.scriptFont(16)
        accountMessage.textColor = UIColor.whiteColor()

        alternateButton.titleLabel?.font = UIFont.scriptFont(16)
        alternateButton.titleLabel?.textColor = UIColor.whiteColor()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Signup
    func saveUser() {
        AccountManager.sharedInstance.saveUser(self, username: emailTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    // Login
    func loginUser() {
        AccountManager.sharedInstance.loginUser(self, email: emailTextField.text!, password: passwordTextField.text!)
    }

    // Alternate Function
    func alternateLoginSignup() {
        
        // Login State
        if signupActive == true {
            
            accountMessage.text = "Don't have an account?"
            alternateButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
            
        // Signup State
        } else {
            
            accountMessage.text = "Already Registered?"
            alternateButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
            
        }
        
    }
    
    
    @IBAction func alternateTrigger(sender: AnyObject) {
        
        alternateLoginSignup()
        delegate?.alternateLoginSignupNav()
        
    }
    
    
    @IBAction func emailDidChange(sender: AnyObject) {
        
        // Valid
        if ((emailTextField.text?.rangeOfString("@")) != nil) {
            emailCheckmark.hidden = false
            emailErrorMessage.hidden = true
            
            // Invalid
        } else {
            emailErrorMessage.hidden = false
            emailCheckmark.hidden = true
            
        }
        
        delegate?.showSignUpButton()
        
        if emailTextField.text == "" {
            delegate?.hideSignUpButton()
        }
        
    }
    
    @IBAction func passwordDidChange(sender: AnyObject) {
        
        // Invalid
        if passwordTextField.text!.characters.count < 8 {
            passwordErrorMessage.hidden = false
            passwordCheckmark.hidden = true
            
            // Valid
        } else {
            passwordCheckmark.hidden = false
            passwordErrorMessage.hidden = true
            
        }
        
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
