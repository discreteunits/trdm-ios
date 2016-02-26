//
//  SignupMessageTableViewCell.swift
//  Pods
//
//  Created by Tobias Robert Brysiewicz on 2/23/16.
//
//

import UIKit

class SignupMessageTableViewCell: UITableViewCell {

    let message = UILabel()
    let alternateButton = UIButton()
    
    // ----------
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Format Elements
        message.frame = CGRectMake(0, 0, 200, 50)
        message.frame.origin.x = 75
        message.font = UIFont.scriptFont(16)
        message.textColor = UIColor.whiteColor()
        
        alternateButton.frame = CGRectMake(0, 0, 125, 50)
        alternateButton.frame.origin.x = 200
        alternateButton.titleLabel?.font = UIFont.scriptFont(16)
        alternateButton.titleLabel?.textColor = UIColor.whiteColor()
        
        // Add Elements
        contentView.addSubview(message)
        contentView.addSubview(alternateButton)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
