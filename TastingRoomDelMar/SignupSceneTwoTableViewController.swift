//
//  SignupSceneTwoTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

@objc
protocol SignupSceneTwoTableViewDelegate {
    func showSignUpButton()
    func hideSignUpButton()
}

class SignupSceneTwoTableViewController: UITableViewController, UITextFieldDelegate {

    var keyboard = CGFloat()
    
    var delegate: SignupSceneTwoTableViewDelegate?
    
    var SignupSceneTwoViewControllerRef: SignUpViewController?
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//    
//    // MARK: - Text field data source
//    @IBAction func emailDidChange(sender: AnyObject) {
//        
//        // Valid
//        if ((emailTextField.text?.rangeOfString("@")) != nil) {
//            emailCheckmark.hidden = false
//            emailErrorMessage.hidden = true
//            
//            // Invalid
//        } else {
//            emailErrorMessage.hidden = false
//            emailCheckmark.hidden = true
//            
//        }
//        
//        delegate?.showSignUpButton()
//        
//        if emailTextField.text == "" {
//            delegate?.hideSignUpButton()
//        }
//        
//    }
//    
//    @IBAction func passwordDidChange(sender: AnyObject) {
//        
//        // Invalid
//        if passwordTextField.text!.characters.count < 8 {
//            passwordErrorMessage.hidden = false
//            passwordCheckmark.hidden = true
//            
//            // Valid
//        } else {
//            passwordCheckmark.hidden = false
//            passwordErrorMessage.hidden = true
//            
//        }
//        
//    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
