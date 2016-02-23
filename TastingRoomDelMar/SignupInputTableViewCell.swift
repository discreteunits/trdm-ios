//
//  SignupInputTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SignupInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let inputLabel = UILabel()
    let inputTextField = UITextField()
    
    let errorMessage = UILabel()
    var checkmark = String()
    
    var checkmarkView = UIImageView()
    
    // ----------
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Format Elements
        inputLabel.frame = CGRectMake(0, 0, 100, 50)
        inputLabel.font = UIFont.headerFont(16)
        inputLabel.textColor = UIColor.whiteColor()
        
        inputTextField.frame = CGRectMake(0, 0, 100, 50)
        inputTextField.frame.origin.x = 100
        inputTextField.autocorrectionType = UITextAutocorrectionType.No
        inputTextField.font = UIFont.headerFont(16)
        inputTextField.textColor = UIColor.whiteColor()
        
        errorMessage.frame = CGRectMake(0, 0, 50, 50)
        errorMessage.font = UIFont.basicFont(10)
        errorMessage.textColor = UIColor.redColor()
        
        checkmark = "checkmark.png"
        let image = UIImage(named: checkmark)
        checkmarkView = UIImageView(image: image!)
        checkmarkView.frame = CGRectMake(0, 0, 50, 50)
        
        // Add Elements
        contentView.addSubview(inputLabel)
        contentView.addSubview(inputTextField)
        contentView.addSubview(errorMessage)
        contentView.addSubview(checkmarkView)
        
        // Hide Elements
        errorMessage.hidden = true
        checkmarkView.hidden = true
        

        
        // Format Constraints
        let yConstraint = NSLayoutConstraint(item: inputLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 0)

        // Add Constraints
        contentView.addConstraint(yConstraint)
        
    }
    
    func inputDidChange(textField: UITextField) {
        
        print("Text field did change.")

        // Valid
        if ((textField.text?.rangeOfString("@")) != nil) {
            errorMessage.hidden = true
            checkmarkView.hidden = false
        // Invalid
        } else {
            errorMessage.hidden = false
            checkmarkView.hidden = true
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        contentView.layer.borderColor = UIColor.redColor().CGColor
    }

}
