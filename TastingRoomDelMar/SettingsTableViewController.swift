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

class SettingsTableViewController: UITableViewController {

    var nav: UINavigationBar?
    
    var selectedValue: String!

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
// -------------------
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
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 2
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell!

        if indexPath.section == 0 {
            
            let myAccountCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell
            myAccountCell.settingLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            myAccountCell.settingValueLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            
            if indexPath.row == 0 {

                myAccountCell.settingLabel.text = "First name"
                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["firstName"] as? String

                return myAccountCell
                
            } else if indexPath.row == 1 {
                
                myAccountCell.settingLabel.text = "Last name"
                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["lastName"] as! String
                
                return myAccountCell
                
            } else if indexPath.row == 2 {
                
                myAccountCell.settingLabel.text = "mobile number"
                myAccountCell.settingValueLabel.text = ""
//                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["mobileNumber"] as! String
                
                return myAccountCell
            } else if indexPath.row == 3 {
                
                myAccountCell.settingLabel.text = "email"
                myAccountCell.settingValueLabel.text = PFUser.currentUser()!["email"] as! String
                
                return myAccountCell
                
            } else if indexPath.row == 4 {
                
                myAccountCell.settingLabel.text = "password"
                myAccountCell.settingValueLabel.text = ""
                
                return myAccountCell
                
            }
            
        } else if indexPath.section == 1 {
            
            let notificationCell = tableView.dequeueReusableCellWithIdentifier("SettingsSwitchTableCell", forIndexPath: indexPath) as! SettingsSwitchTableViewCell
            notificationCell.settingLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
                notificationCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if indexPath.row == 0 {
                
                notificationCell.settingLabel.text = "push notifications"
                
                return notificationCell
                
            } else if indexPath.row == 1 {
                
                notificationCell.settingLabel.text = "Newsletter"
                
                return notificationCell
                
            }
        
        } else if indexPath.section == 2 {
            
            let moreInfoCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell
            moreInfoCell.settingLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            moreInfoCell.settingValueLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            
            
            if indexPath.row == 0 {
                
                moreInfoCell.settingLabel.text = "privacy policy"
                moreInfoCell.settingValueLabel.text = ""
                
                return moreInfoCell
                
            } else if indexPath.row == 1 {
                
                moreInfoCell.settingLabel.text = "terms of use"
                moreInfoCell.settingValueLabel.text = ""
                
                return moreInfoCell
                
            }
            
        } else if indexPath.section == 3 {
            

            
            if indexPath.row == 0 {
                
                let accountActionCell = tableView.dequeueReusableCellWithIdentifier("SettingsLabelTableCell", forIndexPath: indexPath) as! SettingsLabelTableViewCell
                accountActionCell.settingLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
                accountActionCell.settingValueLabel.text = ""
                
                accountActionCell.settingLabel.text = "log out"
                
                return accountActionCell
                
            } else if indexPath.row == 1 {
                
                let footerCell = tableView.dequeueReusableCellWithIdentifier("SettingsFooterTableCell", forIndexPath: indexPath) as! SettingsFooterTableViewCell
                footerCell.versionLabel.font = UIFont(name: "OpenSans", size: 14)
                footerCell.madeInLabel.font = UIFont(name: "OpenSans", size: 8)
                footerCell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return footerCell
                
            }
            
        }
        
        
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRow: UITableViewCell
        
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
        
        } else if indexPath.section == 1 {
        
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                performSegueWithIdentifier("textView", sender: self)
                
            } else if indexPath.row == 1 {
                
                performSegueWithIdentifier("textView", sender: self)
                
            }
        
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                
                PFUser.logOut()
                performSegueWithIdentifier("Landing", sender: self)
                
            }
            
        }
            
    }

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


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editView" {
            
            var vc = segue.destinationViewController as! SettingsEditViewController
            
            vc.passedTrigger = selectedValue
            
        }
        
        
        
    }


}
