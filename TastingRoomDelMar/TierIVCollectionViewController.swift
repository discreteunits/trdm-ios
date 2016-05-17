//
//  TierIVCollectionViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/13/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


@objc
protocol TierIVCollectionViewDelegate {
    func tagsArrayCreation()
    func tierIVCollectionQuery()
    func tierIVTableQuery()
    func reloadTable()
//    func removeTableCellLines()
}


class TierIVCollectionViewController: UICollectionViewController {
    
    var collectionCellWidth = CGFloat()
    
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
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tierIVCollectionArray.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tierIVCollectionCell", forIndexPath: indexPath) as! TierIVCollectionViewCell
        
        cell.titleLabel?.font = UIFont.scriptFont(14)
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 0.4).CGColor
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        

        
        // Show All Cell
        if indexPath.row == 0 {
            
            cell.titleLabel?.text = "Show All"
            cell.selected = true
            collectionCellWidth = 88 // cell.titleLabel.frame.size.width + 32
            
            
        // Every Other Collection Cell
        } else {
        
            let trueIndex = indexPath.row - 1
            cell.titleLabel?.text = self.tierIVCollectionArray[trueIndex]["name"] as? String
            collectionCellWidth = cell.titleLabel.frame.size.width + 32
            

        }
        
        
        if cell.selected == true {
            cell.backgroundColor = UIColor.blackColor()
            cell.titleLabel?.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.titleLabel?.textColor = UIColor.blackColor()
        }
        
        
        return cell

    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let itemsPerRow:CGFloat = 3
//        let hardCodedPadding:CGFloat = 3
//        let itemWidth = (collectionView.bounds.width / itemsPerRow)
        let itemHeight = collectionView.bounds.height - 16
        
        
        return CGSize(width: collectionCellWidth, height: itemHeight)
        
        
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as? TierIVCollectionViewCell {
            
            if selectedCell.selected == true {
                selectedCell.backgroundColor = UIColor.blackColor()
                selectedCell.titleLabel?.textColor = UIColor.whiteColor()
            } else {
                selectedCell.backgroundColor = UIColor.whiteColor()
                selectedCell.titleLabel?.textColor = UIColor.blackColor()
            }
        
        }

        // Show All
        if indexPath.row == 0 {
            
            // Clean Up
            if RouteManager.sharedInstance.Route!.count == 4 {
                RouteManager.sharedInstance.TierFour = nil
            } else {
                print("This selection is already being shown.")
            }
            
            delegate?.tagsArrayCreation()
            delegate?.tierIVTableQuery()
//            delegate?.reloadTable()
            
        // Filter By Selection
        } else {
            
            let showAllCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? TierIVCollectionViewCell
            if showAllCell?.selected == true {
                showAllCell?.selected = false
                showAllCell?.backgroundColor = UIColor.whiteColor()
                showAllCell?.titleLabel?.textColor = UIColor.blackColor()
            }
            
        
            let trueIndex = indexPath.row - 1
            
            if !RouteManager.sharedInstance.Route!.contains(tierIVCollectionArray[trueIndex]) {
                
                if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                    RouteManager.sharedInstance.TierThree = tierIVCollectionArray[trueIndex]
                } else {
                    RouteManager.sharedInstance.TierFour = tierIVCollectionArray[trueIndex]
                }
                
                RouteManager.sharedInstance.printRoute()
                
                delegate?.tagsArrayCreation()
                delegate?.tierIVTableQuery()
                
            } else {
                print("This selection is already being shown.")
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? TierIVCollectionViewCell {
            
            deselectedCell.selected = false
            
            if deselectedCell.selected == true {
                deselectedCell.backgroundColor = UIColor.blackColor()
                deselectedCell.titleLabel?.textColor = UIColor.whiteColor()
            } else {
                deselectedCell.backgroundColor = UIColor.whiteColor()
                deselectedCell.titleLabel?.textColor = UIColor.blackColor()
            }
            
        }
        
        // Remove Selection Upon Deselection
        if RouteManager.sharedInstance.Route!.count == 4 {
            RouteManager.sharedInstance.TierFour = nil
        }
    }
}
