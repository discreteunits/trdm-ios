//
//  SettingsTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/10/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4

class SettingsTableViewController: UITableViewController {

    var nav: UINavigationBar?
    
    var selectedValue: String!

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    // ----------
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        

        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "App Settings"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
        
        }
        
    }
    
    @IBAction func menu(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        TabManager.sharedInstance.addItemsIndicator()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLogIn() {
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "SignupStoryboard", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("createAccount")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func goToHome() {
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "SignupStoryboard", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("Landing")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCellWithIdentifier("SettingsHeaderTableCell") as! SettingsHeaderTableViewCell
            headerCell.headerLabel.font = UIFont(name: "OpenSans", size: 14)
        
        if section == 0 {
            headerCell.headerLabel.text = "MY ACCOUNT"
        } else if section == 1 {
            headerCell.headerLabel.text = "NOTIFICATIONS"
        } else if section == 2 {
            headerCell.headerLabel.text = "MORE INFORMATION"
        } else if section == 3 {
            headerCell.headerLabel.text = "ACCOUNT ACTIONS"
        }
        
        return headerCell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 5
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 3
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        
        // My Account Section
        if indexPath.section == 0 {
            
            let myAccountCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell
            
            myAccountCell.settingLabel.font = UIFont.headerFont(18)
            myAccountCell.settingValueLabel.font = UIFont.headerFont(18)
            
            
            // First Name Row
            if indexPath.row == 0 {

                myAccountCell.settingLabel.text = "First name"
                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["firstName"] as? String

                return myAccountCell
            
            // Last Name Row
            } else if indexPath.row == 1 {
                
                myAccountCell.settingLabel.text = "Last name"
                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["lastName"] as? String
                
                return myAccountCell
            
            // Mobile Number Row
            } else if indexPath.row == 2 {
                
                myAccountCell.settingLabel.text = "mobile number"
                
                if PFUser.currentUser()!["mobileNumber"] as? String != "" {
                    myAccountCell.settingValueLabel.text = PFUser.currentUser()!["mobileNumber"] as? String
                } else {
                    myAccountCell.settingValueLabel.text = ""
                }
                
                return myAccountCell
            
            // Email Row
            } else if indexPath.row == 3 {
                
                myAccountCell.settingLabel.text = "email"
                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["email"] as? String
                
                return myAccountCell
            
            // Password Row
            } else if indexPath.row == 4 {
                
                if PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!) {
                    myAccountCell.settingLabel.text = ""
                    myAccountCell.settingValueLabel.text = ""
                } else {
                    myAccountCell.settingLabel.text = "password"
                    myAccountCell.settingValueLabel.text = ""
                }
                
                return myAccountCell
                
            }
        
        // Notifications Section
        } else if indexPath.section == 1 {
            
            let notificationCell = tableView.dequeueReusableCellWithIdentifier("SettingsSwitchTableCell", forIndexPath: indexPath) as! SettingsSwitchTableViewCell
            
            notificationCell.settingLabel.font = UIFont.headerFont(18)
                notificationCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            // Push Notifications Row
            if indexPath.row == 0 {
                
                notificationCell.settingLabel.text = "push notifications"
                
                return notificationCell
            
            // Newsletter Row
            } else if indexPath.row == 1 {
                
                notificationCell.settingLabel.text = "Newsletter"
                
                return notificationCell
                
            }
        
        // More Information Section
        } else if indexPath.section == 2 {
            
            let moreInfoCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell
            
            moreInfoCell.settingLabel.font = UIFont.headerFont(18)
            moreInfoCell.settingValueLabel.font = UIFont.headerFont(18)
            
            // Privacy Policy Row
            if indexPath.row == 0 {
                
                moreInfoCell.settingLabel.text = "privacy policy"
                moreInfoCell.settingValueLabel.text = ""
                
                return moreInfoCell
                
            // Terms Of Use Row
            } else if indexPath.row == 1 {
                
                moreInfoCell.settingLabel.text = "terms of use"
                moreInfoCell.settingValueLabel.text = ""
                
                return moreInfoCell
                
            }
            
        // Account Actions Section
        } else if indexPath.section == 3 {
            
            // Log Out Row
            if indexPath.row == 0 {
                
                let accountActionCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell
                
                // If Logged In
                if TabManager.sharedInstance.currentTab.userId != "" {

                    accountActionCell.settingLabel.font = UIFont.headerFont(18)
                    accountActionCell.settingValueLabel.text = ""
                    
                    accountActionCell.settingLabel.text = "log out"
                    
                // If NOT Logged In
                } else {

                    accountActionCell.settingLabel.font = UIFont.headerFont(18)
                    accountActionCell.settingValueLabel.text = ""
                
                    accountActionCell.settingLabel.text = "Sign Up"
                    
                }
                
                return accountActionCell
                
            } else if indexPath.row == 1 {
                
                let accountActionCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell

                accountActionCell.settingLabel.font = UIFont.headerFont(18)
                accountActionCell.settingValueLabel.text = ""
                
                accountActionCell.settingLabel.text = "Home"
            
            // Footer
            } else if indexPath.row == 2 {
                
                let footerCell = tableView.dequeueReusableCellWithIdentifier("SettingsFooterTableCell", forIndexPath: indexPath) as! SettingsFooterTableViewCell
                
                footerCell.versionLabel.font = UIFont.basicFont(14)
                footerCell.madeInLabel.font = UIFont.basicFont(8)
                footerCell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return footerCell
                
            }
            
        }
        
        return cell
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // My Account Section
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                selectedValue = "First name"
                
            } else if indexPath.row == 1 {
                selectedValue = "Last name"

            } else if indexPath.row == 2 {
                selectedValue = "mobile number"

            } else if indexPath.row == 3 {
                selectedValue = "email"

            } else if indexPath.row == 4 {
                selectedValue = "password"
                
            }
            
            performSegueWithIdentifier("editView", sender: self)
        
        // Notifications Section
        } else if indexPath.section == 1 {
        
        // More Information Section
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                selectedValue = "Privacy Policy"
                performSegueWithIdentifier("textView", sender: self)
                
            } else if indexPath.row == 1 {
                
                selectedValue = "Terms of Use" 
                performSegueWithIdentifier("textView", sender: self)
                
            }
        
        // Account Actions Section
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                
                if TabManager.sharedInstance.currentTab.userId != "" {
                    
                    PFUser.logOut()
                    
                    // Reset Segue Push Stack
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.resetAppToFirstController()
                    
                } else {
                    
                    goToLogIn()
                    
                }
                
                TabManager.sharedInstance.removeItemsIndicator()
                
            } else if indexPath.row == 1 {
                
                goToHome()
                
            }
            
        }
            
    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editView" {
            
            let vc = segue.destinationViewController as! SettingsEditViewController
            
            vc.passedTrigger = selectedValue
            
        } else if segue.identifier == "textView" {
            
            let vc = segue.destinationViewController as! SettingsTextViewController
            
            vc.passedTrigger = selectedValue
            
        }
        
    }

}
