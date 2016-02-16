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
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        label = UILabel(frame: CGRectMake(0, 0, 50, 20))
        label.frame.origin.y = 0
        label.frame.origin.x = 0
        label.textAlignment = .Center
        label.text = "Cash"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

        
}
