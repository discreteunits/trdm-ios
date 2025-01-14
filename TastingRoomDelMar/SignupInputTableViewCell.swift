//
//  SignupInputTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/23/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SignupInputTableViewCell: UITableViewCell {
    
    let inputLabel = UILabel()
    let inputTextField = UITextField()
    
    let errorMessage = UILabel()
    var checkmark = String()
    
    var checkmarkView = UIImageView()
    
    // ----------
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Bounds
        let screenWidth = contentView.bounds.width
        let screenHeight = contentView.bounds.height
        
        //Format Elements
        inputLabel.frame = CGRectMake(0, 0, 100, 50)
        inputLabel.font = UIFont.headerFont(16)
        inputLabel.textColor = UIColor.whiteColor()
        
        inputTextField.frame = CGRectMake(0, 0, 200, 50)
        inputTextField.frame.origin.x = 100
        inputTextField.autocorrectionType = UITextAutocorrectionType.No
        inputTextField.font = UIFont.headerFont(16)
        inputTextField.textColor = UIColor.whiteColor()
        
        errorMessage.frame = CGRectMake(0, 0, screenWidth * 0.4, 15)
        errorMessage.frame.origin.x = screenWidth * 0.155
        errorMessage.font = UIFont.basicFont(10)
        errorMessage.textColor = UIColor.redColor()
        errorMessage.textAlignment = .Right
        
        checkmark = "checkmark.png"
        let image = UIImage(named: checkmark)
        checkmarkView = UIImageView(image: image!)
        checkmarkView.frame = CGRectMake(0, 0, 30, 30)
        checkmarkView.frame.origin.x = screenWidth * 0.55
        
        // Add Elements
        contentView.addSubview(inputLabel)
        contentView.addSubview(inputTextField)
        contentView.addSubview(errorMessage)
        contentView.addSubview(checkmarkView)
        
        // Hide Elements
        errorMessage.hidden = true
        checkmarkView.hidden = true
        

        
        // Format Constraints
        let yConstraint = NSLayoutConstraint(item: checkmarkView, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 0)

        // Add Constraints
        contentView.addConstraint(yConstraint)
        
    }
    



    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        contentView.layer.borderColor = UIColor.redColor().CGColor
    }

}
