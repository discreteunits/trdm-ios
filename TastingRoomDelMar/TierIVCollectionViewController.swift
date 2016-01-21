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
    func tierIVCollectionQuery()
    func tierIVTableQuery()
    func tagsArrayCreation()
}

class TierIVCollectionViewController: PFQueryCollectionViewController {
    
    var tierIVCollectionArray = [PFObject]()
    
    var TierIVViewControllerRef: TierIVViewController?
    
    var delegate: TierIVCollectionViewDelegate?
    
// ------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.reloadData()
        
        print("\(tierIVCollectionArray)")

    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
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
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
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
        
        route.append(tierIVCollectionArray[indexPath.row])
        print("THE ROUTE IS NOW: \(route)")
        
        delegate?.tagsArrayCreation()
        delegate?.tierIVTableQuery()
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! TierIVCollectionViewCell
        deselectedCell.contentView.backgroundColor = UIColor.whiteColor()
        deselectedCell.titleLabel?.textColor = UIColor.blackColor()

        route.removeAtIndex(3)
        
    }

}
