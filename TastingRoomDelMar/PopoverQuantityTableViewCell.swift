//
//  PopoverQuantityTableViewCell.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/25/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class PopoverQuantityTableViewCell: UITableViewCell {

    @IBOutlet weak var PopoverCollectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
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
            
            PopoverCollectionView.delegate = dataSourceDelegate
            PopoverCollectionView.dataSource = dataSourceDelegate
            PopoverCollectionView.tag = row
            PopoverCollectionView.reloadData()
            
    }
    
}
