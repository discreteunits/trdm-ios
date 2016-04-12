//
//  ItemTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/14/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TierIVTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var altNameTextView: UITextView!
    @IBOutlet weak var varietalLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    
    @IBOutlet weak var tableStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
