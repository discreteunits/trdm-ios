//
//  SettingsSwitchTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


class SettingsSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func `switch`(sender: AnyObject) {
        
        if settingLabel.text == "Push Notifications" {
            
            print("Push notifications switch")
            
            let pushAllowed = settingSwitch
            PFUser.currentUser()!["pushAllowed"] = pushAllowed.enabled
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success, error) in
                
                if error == nil {
                    print("Successfully Switched")
                } else {
                    print("Switch Failure")
                }
            })
            
        } else if settingLabel.text == "Newsletter" {
         
            print("Newsletter switch")
            
            
            
            let marketingAllowed = settingSwitch.enabled
            PFUser.currentUser()!["marketingAllowed"] = marketingAllowed
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success, error) in
                
                if error == nil {
                    print("Successfully Switched")
                } else {
                    print("Switch Failure")
                }
            })
        }

        print("Switched")
        
    }
}
