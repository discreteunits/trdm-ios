//
//  SettingsEditViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SettingsEditViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var nav: UINavigationBar?
    
    var passedTrigger: String!

    var editTitle: String!
    var editMessage: String!
    var editValue: String!
    
    var message: String!
    var placeholder: String!
    
    var SettingsEditTableViewControllerRef: SettingsEditTableViewController?

    var saveButton = UIButton()

    // -------------
    override func viewWillAppear(animated: Bool) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.addSignupButton()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = passedTrigger
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
//            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< Settings", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingsEditViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont.scriptFont(20)], forState: UIControlState.Normal)
            
        }
        
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSignupButton() {
        
        // Sign Up Button
        let screenSize = self.view.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let keyboardHeight = self.SettingsEditTableViewControllerRef?.keyboard
        print("\(keyboardHeight)")
        let topOfKeyboard = (screenHeight - keyboardHeight!) - 68
        
        saveButton = UIButton(frame: CGRectMake(0, topOfKeyboard, screenWidth, 60))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        saveButton.titleLabel?.font = UIFont.scriptFont(24)
//        saveButton.addTarget(self, action: "saveChanges:", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: #selector(SettingsEditViewController.saveChanges), forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.hidden = true
        
        self.view.addSubview(saveButton)
        
    }
    
    func saveChanges() {
        
        self.SettingsEditTableViewControllerRef?.saveValue()
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func showValueToEdit() {
        
        if passedTrigger == "First name" {
            message = "This is how you'll appear in notifications and emails from Tasting Room."
            placeholder = PFUser.currentUser()!["firstName"] as! String
            
        } else if passedTrigger == "Last name" {
            message = "This is how you'll appear in notifications and emails from Tasting Room."
            placeholder = PFUser.currentUser()!["lastName"] as! String
            
        } else if passedTrigger == "Mobile Number" {
            message = "This is how you'll receive notifications and emails from Tasting Room."
            
            if let placeholderValue = PFUser.currentUser()?["mobileNumber"] as? String {
                placeholder = placeholderValue
            } else {
                placeholder = ""    
            }
            
        } else if passedTrigger == "Email" {
            message = "This is how you'll receive notifications and emails from Tasting Room."
            placeholder = PFUser.currentUser()!["email"] as! String
            
        } else if passedTrigger == "Password" {
            message = "This is how you'll log into the Tasting Room app."
            placeholder = "password"
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SettingEditEmbeded" {
            
            if let SettingsEditTableViewController = segue.destinationViewController as? SettingsEditTableViewController {
                
                self.SettingsEditTableViewControllerRef = SettingsEditTableViewController
                
                SettingsEditTableViewController.delegate = self
                
                showValueToEdit()
                SettingsEditTableViewController.passedEditType = self.passedTrigger // Sets value to edit
                SettingsEditTableViewController.passedMessage = message
                SettingsEditTableViewController.passedPlaceholder = placeholder
                
            }
            
        }
        
    }

}

extension SettingsEditViewController: SettingsEditTableViewDelegate {
    
    func showSaveButton() {
        AnimationManager.sharedInstance.showButtonVertical(self, button: saveButton)
    }
    
    func hideSaveButton() {
        AnimationManager.sharedInstance.hideButtonVertical(self, button: saveButton)
    }
    
}
