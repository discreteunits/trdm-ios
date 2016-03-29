//
//  TabTotalTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TabTotalTableViewCell: UITableViewCell {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var subtotalValueLabel: UILabel!
    
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
