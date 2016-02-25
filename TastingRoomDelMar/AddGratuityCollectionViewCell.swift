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
        
        contentView.addSubview(label)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

        
}
