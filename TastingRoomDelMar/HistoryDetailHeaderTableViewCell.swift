//
//  HistoryHeaderTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class HistoryDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // ------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
