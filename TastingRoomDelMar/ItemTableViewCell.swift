//
//  ItemTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/14/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var addToOrderButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var altNameLabel: UILabel!
    @IBOutlet weak var varietalLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
