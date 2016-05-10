//
//  HistoryTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var openCloseOrderLabel: UILabel!
    
    
    // ----------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
