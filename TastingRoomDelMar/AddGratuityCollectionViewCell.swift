//
//  AddGratuityCollectionViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class AddGratuityCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    var percentSignLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let screenWidth = self.bounds.width
        let screenHeight = self.bounds.height
        
        label = UILabel(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        label.frame.origin.y = 0
        label.frame.origin.x = 0
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        label.text = "Cash"
        label.font = UIFont.scriptFont(18)
        
        percentSignLabel = UILabel(frame: CGRectMake(0,0, screenWidth * 0.78, screenHeight))
        percentSignLabel.frame.origin.y = 0
        percentSignLabel.frame.origin.x = 0
        percentSignLabel.textAlignment = .Right
        percentSignLabel.backgroundColor = UIColor.clearColor()
        percentSignLabel.textColor = UIColor.blackColor()
        percentSignLabel.text = "%"
        percentSignLabel.font = UIFont.scriptFont(18)
        percentSignLabel.layer.zPosition = 99999
        
        contentView.addSubview(percentSignLabel)
        contentView.addSubview(label)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
}
