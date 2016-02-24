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
    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var emailCheckmark: UIImageView!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var passwordCheckmark: UIImageView!
    
    @IBOutlet weak var registeredMessage: UILabel!
    @IBOutlet weak var alternateButton: UIButton!
    
    var keyboard = CGFloat()
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        
        message = "Already have an account?"
        buttonText = "Log In"
        
        
        
        emailLabel.font = UIFont.headerFont(16)
        emailTextField.font = UIFont.headerFont(16)
        emailErrorMessage.hidden = true
        emailCheckmark.hidden = true
        
        emailTextField.becomeFirstResponder()
        
        passwordTextField.font = UIFont.headerFont(16)
        passwordLabel.font = UIFont.headerFont(16)
        passwordErrorMessage.hidden = true
        passwordCheckmark.hidden = true
        
        alternateButton.titleLabel?.font = UIFont.scriptFont(16)
        registeredMessage.font = UIFont.scriptFont(16)
        


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

    
    func keyboardWillShow(notification:NSNotification) {
        print("Keyboard Appeared")
        
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        print("KeyboardHeight: \(keyboardHeight)")
        
        keyboard = keyboardHeight
        
    }
    
    // MARK: - Text field data source
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


}
