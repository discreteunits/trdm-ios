//
//  TierIVCollectionViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/13/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import ParseCrashReporting

@objc
protocol TierIVCollectionViewDelegate {
    func tagsArrayCreation()
    func tierIVCollectionQuery()
    func tierIVTableQuery()
}

class TierIVCollectionViewController: UICollectionViewController {
    
    var TierIVViewControllerRef: TierIVViewController?
    
    var delegate: TierIVCollectionViewDelegate?
    
    var tierIVCollectionArray: [PFObject]!
    var collectionArray = [PFObject]() {
        didSet {
            tierIVCollectionArray = collectionArray
        }
    }
    
// ------------------

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tierIVCollectionArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tierIVCollectionCell", forIndexPath: indexPath) as! TierIVCollectionViewCell

        cell.titleLabel?.text = self.tierIVCollectionArray[indexPath.row]["name"] as? String
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 3
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (4 * hardCodedPadding)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! TierIVCollectionViewCell
        selectedCell.layer.cornerRadius = 10.0
        selectedCell.clipsToBounds = true
        selectedCell.contentView.backgroundColor = UIColor.blackColor()
        selectedCell.titleLabel?.textColor = UIColor.whiteColor()
        
        if !route.contains(tierIVCollectionArray[indexPath.row]) {
            
            route.append(tierIVCollectionArray[indexPath.row])
            print("The route is now: \(route)")
            
        } else {
            
            print("Warning: This selection is already in the route.")
            
        }
        
        delegate?.tagsArrayCreation()
        delegate?.tierIVTableQuery()
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! TierIVCollectionViewCell
        deselectedCell.contentView.backgroundColor = UIColor.whiteColor()
        deselectedCell.titleLabel?.textColor = UIColor.blackColor()

        route.removeAtIndex(3)
        delegate?.tagsArrayCreation()

        
    }

}
