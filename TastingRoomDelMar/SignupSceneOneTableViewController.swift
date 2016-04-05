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
    
    var SignupSceneOneViewControllerRef: SignupSceneOneViewController?
    
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
        
        // Get Keyboard Height
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignupSceneOneTableViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)

        // Format Elements
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
    func saveUser(view: UIViewController) {
        
        let username = emailTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        AccountManager.sharedInstance.saveUser(view, username: username!, email: email!, password: password!)
    }
    
    // Login
    func loginUser(view: UIViewController) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        AccountManager.sharedInstance.loginUser(view, email: email!, password: password!)
        
    }
    
    func alternateTrigger(sender: AnyObject) {
        
        alternateSignupLogin()
        delegate?.alternateLoginSignupNav()
        
        self.tableView.reloadData()
        
    }
    
    func alternateSignupLogin() {
        
        // Login State
        if signupActive == true {
          
            registeredMessage.text = "Don't have an account?"
            alternateButton.setTitle("Sign Up", forState: .Normal)
            
            signupActive = false
            
        // Signup State
        } else {
            
            registeredMessage.text = "Already registered?"
            alternateButton.setTitle("Log In", forState: .Normal)
            
            signupActive = true
            
        }
        
    }
    
    @IBAction func alternate(sender: AnyObject) {
        
        alternateSignupLogin()
        delegate?.alternateLoginSignupNav()
        
        self.tableView.reloadData()
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        
        if printFlag {
            print("Keyboard Appeared")
        }
        
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        if printFlag {
            print("KeyboardHeight: \(keyboardHeight)")
        }
        
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
