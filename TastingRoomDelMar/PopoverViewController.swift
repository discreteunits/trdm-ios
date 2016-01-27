//
//  PopoverViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/18/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class PopoverViewController: UITableViewController {

    var popoverItem: PFObject!
    var popoverItemVarietal: PFObject!
    
    var rows: Int!
    
    var qty = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var actions = ["Cancel", "Add to Order"]
    
    let model: [[UIColor]] = generateRandomData()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            let mg = popoverItem["modifierGroups"].count
            rows = mg + 3
            return rows
    }
    

    
    
// TABLE ROWS
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            var cell: UITableViewCell!
            let quantityRow = rows - 2
            let actionRow = rows - 1
            
            if indexPath.row == 0 {
                var detailsCell: PopoverDetailsTableViewCell
                detailsCell = tableView.dequeueReusableCellWithIdentifier("PopoverDetailsTableCell",
                    forIndexPath: indexPath) as! PopoverDetailsTableViewCell
                detailsCell.contentView.tag = indexPath.row
                detailsCell.titleLabel?.text = popoverItem["name"] as! String!
                detailsCell.altNameLabel?.text = popoverItem["alternateName"] as! String!
                detailsCell.varietalLabel?.text = popoverItemVarietal["name"] as! String!
                detailsCell.selectionStyle = UITableViewCellSelectionStyle.None

                return detailsCell
                
            } else if (indexPath.row > 0) && (indexPath.row < quantityRow) {
                var mgCell: PopoverMGTableViewCell
                mgCell = tableView.dequeueReusableCellWithIdentifier("PopoverMGTableCell",
                    forIndexPath: indexPath) as! PopoverMGTableViewCell
                mgCell.contentView.tag = indexPath.row
                mgCell.servingLabel.text = "serving"
                
                return mgCell
                
            } else if indexPath.row == quantityRow {
                var qtyCell: PopoverQuantityTableViewCell
                qtyCell = tableView.dequeueReusableCellWithIdentifier("PopoverQuantityTableCell",
                    forIndexPath: indexPath) as! PopoverQuantityTableViewCell
                qtyCell.contentView.tag = indexPath.row
                qtyCell.label.text = "quantity"
                
                return qtyCell
                
            } else if indexPath.row == actionRow {
                var actionCell: PopoverActionTableViewCell
                actionCell = tableView.dequeueReusableCellWithIdentifier("PopoverActionTableCell",
                    forIndexPath: indexPath) as! PopoverActionTableViewCell
                actionCell.contentView.tag = indexPath.row
    
                return actionCell
            }
            
            return cell
            
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            var tableViewCell: UITableViewCell!
            let quantityRow = rows - 2
            let actionRow = rows - 1
            
            if indexPath.row == 0 {
                guard let tableViewCell = cell as? PopoverDetailsTableViewCell else { return }
//                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                

            } else if (indexPath.row > 0) && (indexPath.row < quantityRow ) {
                guard let tableViewCell = cell as? PopoverMGTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

            } else if indexPath.row == quantityRow {
                guard let tableViewCell = cell as? PopoverQuantityTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

            } else if indexPath.row == actionRow {
                guard let tableViewCell = cell as? PopoverActionTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

            }
            
            
            
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

// -------------------------
// COLLECTION DELEGATE AND DATA SOURCE
// -------------------------
extension PopoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            let parent = collectionView.superview!.tag
            let quantityRow = rows - 2
            let actionRow = rows - 1
            
            var numberOfItems: Int!
            
            if parent == 0 {
                numberOfItems = 1
                // PARENT ZERO IS NOT A COLLECTION VIEW
            } else if (parent > 0) && (parent < quantityRow ) {
                numberOfItems = 3

            } else if parent == quantityRow {
                numberOfItems = qty.count

            } else if parent == actionRow {
                numberOfItems = 2

            }
            
            return numberOfItems
            
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            var cell: UICollectionViewCell!
            
            let parent = collectionView.superview!.tag
            let quantityRow = rows - 2
            let actionRow = rows - 1
            
            
            if parent == 0 {
                // PARENT ZERO IS NOT A COLLECTION VIEW
            } else if (parent > 0) && (parent < quantityRow ) {
                
                var mgCollectionCell: PopoverMGCollectionViewCell
                mgCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverMGCollectionCell",
                    forIndexPath: indexPath) as! PopoverMGCollectionViewCell
                
                mgCollectionCell.backgroundColor = UIColor.whiteColor()
                
//                for modifier in popoverItem["modifierGroups"] {
//                    
//                }
                
                return mgCollectionCell
                
            } else if parent == quantityRow {
                
                var quantityCollectionCell: PopoverQuantityCollectionViewCell
                quantityCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverQuantityCollectionCell",
                    forIndexPath: indexPath) as! PopoverQuantityCollectionViewCell
                
                quantityCollectionCell.backgroundColor = UIColor.whiteColor()
                var index = String(indexPath.row + 1)
                quantityCollectionCell.label.text = index
                
                return quantityCollectionCell
                
            } else if parent == actionRow {
                
                var actionCollectionCell: PopoverActionCollectionViewCell
                actionCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverActionCollectionCell",
                    forIndexPath: indexPath) as! PopoverActionCollectionViewCell
                
                if indexPath.row == 0 {
                    
                    actionCollectionCell.backgroundColor = UIColor.grayColor()
                    actionCollectionCell.label.textColor = UIColor.whiteColor()
                    actionCollectionCell.label.text = "Cancel"
                    
                } else if indexPath.row == 1 {
                    
                    actionCollectionCell.backgroundColor = UIColor.blackColor()
                    actionCollectionCell.label.textColor = UIColor.whiteColor()
                    actionCollectionCell.label.text = "Add to Order"

                }
                
                return actionCollectionCell
                
            }
            
            
            
            return cell
    }
 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! UICollectionViewCell
        selectedCell.backgroundColor = UIColor.blackColor()
        
        
        let parent = collectionView.superview!.tag
        let quantityRow = rows - 2
        let actionRow = rows - 1
        
        if parent == 0 {
            // PARENT ZERO IS NOT A COLLECTION VIEW
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverMGCollectionViewCell
            selectedCell.layer.cornerRadius = 10.0
            selectedCell.clipsToBounds = true
            selectedCell.label.textColor = UIColor.whiteColor()
            selectedCell.priceLabel.textColor = UIColor.whiteColor()

            
        } else if parent == quantityRow {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverQuantityCollectionViewCell
            selectedCell.layer.cornerRadius = 10.0
            selectedCell.clipsToBounds = true
            selectedCell.label.textColor = UIColor.whiteColor()
            
        } else if parent == actionRow {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverActionCollectionViewCell
            
            if indexPath.row == 0 {

                selectedCell.label.textColor = UIColor.blackColor()
                selectedCell.contentView.backgroundColor = UIColor.whiteColor()

            } else if indexPath.row == 1 {
                selectedCell.label.textColor = UIColor.blackColor()
                selectedCell.contentView.backgroundColor = UIColor.greenColor()

            }
            
        }
        
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! UICollectionViewCell
        deselectedCell.contentView.backgroundColor = UIColor.whiteColor()
     
        
        
        let parent = collectionView.superview!.tag
        let quantityRow = rows - 2
        let actionRow = rows - 1
        
        if parent == 0 {
            // PARENT ZERO IS NOT A COLLECTION VIEW
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverMGCollectionViewCell
            deselectedCell.label.textColor = UIColor.blackColor()
            deselectedCell.priceLabel.textColor = UIColor.blackColor()
            
            
        } else if parent == quantityRow {
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverQuantityCollectionViewCell
            deselectedCell.label.textColor = UIColor.blackColor()
            
        } else if parent == actionRow {
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverActionCollectionViewCell
            if indexPath.row == 0 {
                deselectedCell.label.textColor = UIColor.blackColor()
                deselectedCell.contentView.backgroundColor = UIColor.grayColor()

            } else if indexPath.row == 1 {
                deselectedCell.label.textColor = UIColor.whiteColor()
                deselectedCell.contentView.backgroundColor = UIColor.blackColor()

            }
        }
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cellSize: CGSize!
        let parent = collectionView.superview!.tag
        let quantityRow = rows - 2
        let actionRow = rows - 1
        
        
        if parent == 0 {
            // PARENT ZERO IS NOT A COLLECTION VIEW
        } else if (parent > 0) && (parent < quantityRow ) {
            var mgCellSize: CGSize!
            let cellHeight = collectionView.bounds.size.height
            let cellWidth = collectionView.bounds.size.width / 3
            
            mgCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return mgCellSize
            
        } else if parent == quantityRow {
            var quantityCellSize: CGSize!
            let cellHeight = collectionView.bounds.size.height
            let cellWidth = collectionView.bounds.size.width / 5
            
            quantityCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return quantityCellSize
            
        } else if parent == actionRow {
            var actionCellSize: CGSize!
            let cellHeight = collectionView.bounds.size.height
            let cellWidth = collectionView.bounds.size.width / 2
            
            actionCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return actionCellSize
            
        }
        
        
        return cellSize
    }
    
}
