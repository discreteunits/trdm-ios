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

    
// -------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = passedTrigger
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    
    @IBAction func saveEdit(sender: AnyObject) {
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
            
        } else if passedTrigger == "mobile number" {
            message = "This is how you'll receive notifications and emails from Tasting Room."
            placeholder = PFUser.currentUser()!["mobileNumber"] as! String
            
        } else if passedTrigger == "email" {
            message = "This is how you'll receive notifications and emails from Tasting Room."
            placeholder = PFUser.currentUser()!["email"] as! String
            
        } else if passedTrigger == "password" {
            message = "This is how you'll log into the Tasting Room app."
            //            field = PFUser.currentUser()!["password"] as! String
            placeholder = "password"
            
        }
        
    }

}

extension SettingsEditViewController: SettingsEditTableViewDelegate {
 

    
}
