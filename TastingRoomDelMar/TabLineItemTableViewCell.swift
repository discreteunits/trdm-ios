//
//  TabLineItemTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TabLineItemTableViewCell: UITableViewCell {

    @IBOutlet weak var TabCollectionView: UICollectionView!

    @IBOutlet weak var itemNameLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
            
            TabCollectionView.delegate = dataSourceDelegate
            TabCollectionView.dataSource = dataSourceDelegate
            TabCollectionView.tag = row
            TabCollectionView.reloadData()
    }

}
