//
//  PopoverTableViewCell.swift
//  
//
//  Created by Tobias Robert Brysiewicz on 1/18/16.
//
//

import UIKit

class PopoverTableViewCell: UITableViewCell {

    @IBOutlet private weak var PopoverCollectionView: UICollectionView!
    
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
