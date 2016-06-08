//
//  SignupSceneTwoTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

@objc
protocol SignupSceneTwoTableViewDelegate {
    func showSignUpButton()
    func hideSignUpButton()
}

class SignupSceneTwoTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var newsletterLabel: UILabel!
    @IBOutlet weak var newsletterSwitch: UISwitch!
    
    var keyboard = CGFloat()
    
    var delegate: SignupSceneTwoTableViewDelegate?
    
    var SignupSceneTwoViewControllerRef: SignupSceneTwoViewController?
    
    // ----------
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.scrollEnabled = false
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.backgroundColor = UIColor.blackColor()
        
        tableView.estimatedRowHeight = 50
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Keyboard Height
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignupSceneTwoTableViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        // Format Elements
        firstNameLabel.font = UIFont.headerFont(16)
        firstNameTextField.font = UIFont.headerFont(16)
        
        firstNameTextField.becomeFirstResponder()
        
        lastNameLabel.font = UIFont.headerFont(16)
        lastNameTextField.font = UIFont.headerFont(16)
        
        mobileLabel.font = UIFont.headerFont(16)
        mobileTextField.font = UIFont.headerFont(16)
        
        newsletterLabel.font = UIFont.headerFont(16)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func editingDidChange(sender: AnyObject) {
        
        if printFlag {
            print("Editing did change")
        }
        
        
        if firstNameTextField.text != "" && lastNameTextField.text != "" {
            delegate?.showSignUpButton()
        }
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" {
            delegate?.hideSignUpButton()
        }
        
    }
    
    
    
    @IBAction func lastNameEditingDidChange(sender: AnyObject) {
        
        if printFlag {
            print("Editing did change")
        }
        
        
        if firstNameTextField.text != "" && lastNameTextField.text != "" {
            delegate?.showSignUpButton()
        }
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" {
            delegate?.hideSignUpButton()
        }
        
    }
    
    
    func addDetailsToUser() {
        
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let mobile = mobileTextField.text
        
        var newsletter = Bool()
        
        if newsletterSwitch.on {
            newsletter = true
        } else {
            newsletter = false
        }

        AccountManager.sharedInstance.addUserDetails(self, firstName: firstName!, lastName: lastName!, mobile: mobile!, newsletter: newsletter)
        
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
