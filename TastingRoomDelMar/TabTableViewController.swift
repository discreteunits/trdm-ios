//
//  TabTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

@objc
protocol TabTableViewDelegate {
    
}

class TabTableViewController: UITableViewController {

    // Table Cell Row Indicators
    var rows: Int!
    var totalRow: Int!
    var actionRow: Int!

    //
    var tab = TabManager.sharedInstance.currentTab
    
    // Protocol Delegate
    var TabViewControllerRef: TabViewController?
    var delegate: TabTableViewDelegate?
    
    
    var containerViewController: TabViewController?

    
    
// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        // Scroll to bottom of table
        dispatch_async(dispatch_get_main_queue()) {
            let indexPath = NSIndexPath(forRow: self.actionRow, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("TabHeaderCell") as! TabHeaderTableViewCell
        
        headerCell.itemLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
        headerCell.qtyLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
        headerCell.priceLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
        
        return headerCell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = TabManager.sharedInstance.currentTab.lines.count + 2
        totalRow = rows - 2
        actionRow = rows - 1
        
        return rows
        
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        // Line Item Table Row
        if indexPath.row < totalRow {
            
            var lineitemCell: TabLineItemTableViewCell
            lineitemCell = tableView.dequeueReusableCellWithIdentifier("TabLineItemTableCell", forIndexPath: indexPath) as! TabLineItemTableViewCell
  
            // Connect Specific Table Cell With Specific Colleciton View
            lineitemCell.contentView.tag = indexPath.row
            
            // Assignments
            lineitemCell.itemNameLabel?.text = "\(tab.lines[indexPath.row].name)"
            
            // Styles
            lineitemCell.itemNameLabel.font = UIFont(name: "BebasNeueRegular", size: 24)

            
            return lineitemCell

            
        // Total Table Row
        } else if indexPath.row == totalRow {
            
            var totalCell: TabTotalTableViewCell
            totalCell = tableView.dequeueReusableCellWithIdentifier("TabTotalTableCell", forIndexPath: indexPath) as! TabTotalTableViewCell
            
            // Assignments
            totalCell.subtotalValueLabel?.text = "\(tab.subtotal)"
            totalCell.taxValueLabel?.text = "\(tab.totalTax)"
            totalCell.totalValueLabel?.text = "\(tab.grandTotal)"
            
            // Styles
            totalCell.subtotalLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            totalCell.taxLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            totalCell.totalLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            
            totalCell.subtotalValueLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            totalCell.taxValueLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            totalCell.totalValueLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            
            
            return totalCell

            
        // Action Table Row
        } else if indexPath.row == actionRow {
            
            var actionCell: TabActionTableViewCell
            
            actionCell = tableView.dequeueReusableCellWithIdentifier("TabActionTableCell", forIndexPath: indexPath) as! TabActionTableViewCell

            // Styles
            actionCell.closeOrderButton.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
            actionCell.closeOrderButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            actionCell.closeOrderButton.layer.cornerRadius = 6.0
            actionCell.closeOrderButton.clipsToBounds = true
            actionCell.closeOrderButton.titleLabel?.textColor = UIColor.blackColor()

            
            actionCell.placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
            actionCell.placeOrderButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            actionCell.placeOrderButton.layer.cornerRadius = 6.0
            actionCell.placeOrderButton.clipsToBounds = true
            actionCell.placeOrderButton.titleLabel?.textColor = UIColor.whiteColor()
            
            return actionCell

            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            var tableViewCell: UITableViewCell!
            
            // Lineitem Table Row
            if indexPath.row < totalRow {
                
                guard let tableViewCell = cell as? TabLineItemTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                
            // Total Table Row
            } else if indexPath.row == totalRow {
                
                guard let tableViewCell = cell as? TabTotalTableViewCell else { return }
                
            // Action Table Row
            } else if indexPath.row == actionRow {
                
                guard let tableViewCell = cell as? TabActionTableViewCell else { return }
                
            }
            
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cellSize: CGFloat!

        if indexPath.row < totalRow {
            
            let lineMods = tab.lines[indexPath.row].modifiers.count
            let lineSize = lineMods * 25 + 50
            
            return CGFloat(lineSize)
            
        } else if indexPath.row == totalRow {
            
            return 100
            
        } else if indexPath.row == actionRow {

            return 100
            
        }
        
        return cellSize

    }




    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        // LineItem Row
        if indexPath.row < totalRow {
            return true
        // Total Row
        } else if indexPath.row == totalRow {
            return false
        // Action Row
        } else if indexPath.row == actionRow {
            return false
        }
        
        return false
        
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tab.lines.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// -----------------------------------
// COLLECTION DELEGATE AND DATA SOURCE
// -----------------------------------
extension TabTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let parent = collectionView.superview!.tag
        var numberOfItems: Int!

        if parent < totalRow {
            
            let modChoices = tab.lines[0].modifiers.count
            numberOfItems = modChoices
            
        }
        
        return numberOfItems
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        let parent = collectionView.superview!.tag
        
        if parent < totalRow {
            
            // Serving Modifier Collection Row
            if indexPath.row == 0 {
                
                var lineitemServingCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemServingCollectionCell", forIndexPath: indexPath) as! TabLineItemServingCollectionViewCell

                // Assignments
                //// Declare Pair for Presentation
                let orderMod = tab.lines[parent].modifiers[indexPath.row].name
                let servingPrice = "\(Int(tab.lines[parent].modifiers[indexPath.row].price))"
                let orderAndServing = orderMod + "   " + servingPrice
                lineitemServingCollectionCell.servingSizeLabel?.text = "\(orderAndServing)"
                
                lineitemServingCollectionCell.qtyLabel?.text = "\(Int(tab.lines[parent].quantity))"
                
                lineitemServingCollectionCell.priceLabel?.text = "\(Int(tab.lines[parent].price))"

                
                // Styles
                lineitemServingCollectionCell.backgroundColor = UIColor.whiteColor()
                lineitemServingCollectionCell.servingSizeLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                lineitemServingCollectionCell.qtyLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                lineitemServingCollectionCell.priceLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                
                return lineitemServingCollectionCell
                
                
            // All Other Modifier Colleciton Rows
            } else {
               
                var lineitemCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemCollectionCell", forIndexPath: indexPath) as! TabLineItemCollectionViewCell
                
                // Assignment
                lineitemCollectionCell.modNameLabel?.text = "\(tab.lines[parent].modifiers[indexPath.row].name)"
                
                // Styles
                lineitemCollectionCell.backgroundColor = UIColor.whiteColor()
                lineitemCollectionCell.modNameLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                
                return lineitemCollectionCell
                
            }
            
        }
        
        return cell
        
    }
    
    
    // Size Collection Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cellSize: CGSize!
        let parent = collectionView.superview!.tag
        
        if parent < totalRow {

            var collectionLineSize: CGSize!
            
            let cellWidth = collectionView.bounds.size.width - 10
            let cellHeight = CGFloat(25)
            
            collectionLineSize = CGSize(width: cellWidth, height: cellHeight)
            
            return collectionLineSize
            
        } else if indexPath.row == totalRow {
            
            // Do nothing
            
        } else if indexPath.row == actionRow {
            
            // Do nothing
            
        }
        
        return cellSize
        
        
    }
    
    
    
    
}
