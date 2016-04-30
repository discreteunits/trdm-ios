//
//  TabTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

@objc
protocol TabTableViewDelegate {
    func defaultScreen()
    func getView() -> UIView
<<<<<<< HEAD
    func recalculateTotals() 
=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
}

class TabTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {

    var rows = Int()
    
    @IBOutlet var tabTableView: UITableView!
    
    var AlertManagerRef: AlertManager?
    
    var delegate: TabTableViewDelegate?
    
    // Price Formatter
    let formatter = PriceFormatManager.priceFormatManager

    var numberOfItems: Int!

// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        if TabManager.sharedInstance.currentTab.lines.count > 0 {
            // Scroll to bottom of table
            dispatch_async(dispatch_get_main_queue()) {
                let indexPath = NSIndexPath(forRow: TabManager.sharedInstance.currentTab.lines.count - 1, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
            }
=======
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        // Scroll to bottom of table
        dispatch_async(dispatch_get_main_queue()) {
            let indexPath = NSIndexPath(forRow: TabManager.sharedInstance.currentTab.lines.count - 1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // Mark: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("TabHeaderCell") as! TabHeaderTableViewCell
        
        headerCell.itemLabel.font = UIFont.headerFont(18)
        headerCell.qtyLabel.font = UIFont.headerFont(18)
        headerCell.priceLabel.font = UIFont.headerFont(18)
        
        return headerCell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = TabManager.sharedInstance.currentTab.lines.count
        
        return rows
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            var lineitemCell: TabLineItemTableViewCell
            lineitemCell = tableView.dequeueReusableCellWithIdentifier("TabLineItemTableCell", forIndexPath: indexPath) as! TabLineItemTableViewCell
  
            // Connect Specific Table Cell With Specific Colleciton View
            lineitemCell.contentView.tag = indexPath.row
            
            // Assignments
            lineitemCell.itemNameLabel?.text = "\(TabManager.sharedInstance.currentTab.lines[indexPath.row].name)"
            
            // Styles
            lineitemCell.itemNameLabel.font = UIFont.headerFont(24)
            
            return lineitemCell

    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? TabLineItemTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
      
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cellSize = CGFloat()

        // ----- HARVEST BEGIN ------
        if TabManager.sharedInstance.currentTab.lines[indexPath.row].path == "Eat" {
                
            let lineMods = TabManager.sharedInstance.currentTab.lines[indexPath.row].additions.count
            let lineModsWithServing = lineMods + 1
<<<<<<< HEAD
            let lineSize = (lineModsWithServing * 25) + 90
=======
            let lineSize = (lineModsWithServing * 25) + 75
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
            
            return CGFloat(lineSize)
            
        } else {
               
            if TabManager.sharedInstance.currentTab.lines.count > 0 {
                    
<<<<<<< HEAD
                let lineSize = 90
=======
                let lineSize = 80
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
                return CGFloat(lineSize)
                    
            }
        }
        // ----- END -----

        return cellSize

    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.tableView.beginUpdates()


            // Remove Line Item From Tab Struct
            TabManager.sharedInstance.currentTab.lines.removeAtIndex(indexPath.row)
            // Remove Row From Table
            self.tableView.deleteRowsAtIndexPaths(NSArray(object: NSIndexPath(forRow: indexPath.row, inSection: 0)) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Left)
            
<<<<<<< HEAD
            
=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
            if TabManager.sharedInstance.currentTab.lines.count == 0 {
                self.dismissViewControllerAnimated(false, completion: nil)
            }


        }
        
<<<<<<< HEAD
        // Trigger Function in Floating Table File To Reload
        delegate?.recalculateTotals()
        
        
        self.tableView.endUpdates()

        TabManager.sharedInstance.totalCellCalculator()

=======
        self.tableView.endUpdates()

        TabManager.sharedInstance.totalCellCalculator()
        
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        self.tableView.reloadData()

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // This Controller Does Not Segue
        
    }
}

// Mark: Collection Data Source
extension TabTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let parent = collectionView.superview!.tag

        // ----- HARVEST BEGIN ------
        if TabManager.sharedInstance.currentTab.lines[parent].path == "Eat" {
                
            let modChoices = TabManager.sharedInstance.currentTab.lines[parent].additions.count
            numberOfItems = modChoices + 2
                
        } else {
                
            let modChoices = 2
            numberOfItems = modChoices
                
        }
        // ----- END -----

        
        return numberOfItems
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let parent = collectionView.superview!.tag
        
        
        // Serving Cell Defaulted To Top
        if indexPath.row == 0 {
            
            let lineitemServingCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemServingCollectionCell", forIndexPath: indexPath) as! TabLineItemServingCollectionViewCell
            
            var servingPrice = String()
            var orderMod = String()

            if TabManager.sharedInstance.currentTab.lines[parent].path == "Merch" {
                    
                orderMod = ""
                servingPrice = ""
                    
            } else if TabManager.sharedInstance.currentTab.lines[parent].path == "Event" {
                    
                orderMod = ""
                servingPrice = ""
                    
            } else if TabManager.sharedInstance.currentTab.lines[parent].path == "Eat" {
                
                orderMod = TabManager.sharedInstance.currentTab.lines[parent].name
                servingPrice = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].product.price))"
                    
            } else if TabManager.sharedInstance.currentTab.lines[parent].path == "More" {
                    
                orderMod = ""
                servingPrice = ""
                   
            } else if TabManager.sharedInstance.currentTab.lines[parent].path == "Flights" {

                orderMod = ""
                servingPrice = ""
                    
            } else {
                
                orderMod = TabManager.sharedInstance.currentTab.lines[parent].subproduct.info
                servingPrice = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].subproduct.price))"
                    
            }
                

            let orderAndServing = orderMod + "   " + servingPrice
            lineitemServingCollectionCell.servingSizeLabel?.text = "\(orderAndServing)"
                
            lineitemServingCollectionCell.qtyLabel?.text = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].quantity))"
                
            lineitemServingCollectionCell.priceLabel?.text = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].price))"

                
            // Styles
            lineitemServingCollectionCell.backgroundColor = UIColor.whiteColor()
            lineitemServingCollectionCell.servingSizeLabel.font = UIFont.scriptFont(18)
            lineitemServingCollectionCell.qtyLabel.font = UIFont.scriptFont(18)
            lineitemServingCollectionCell.priceLabel.font = UIFont.scriptFont(18)
                
                
            return lineitemServingCollectionCell
            
            
        // Modifier Cells
        } else if indexPath.row < (numberOfItems - 1) {
        
            
            let lineitemCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemCollectionCell", forIndexPath: indexPath) as! TabLineItemCollectionViewCell
                    
            // ----- IF HARVEST -----
            if TabManager.sharedInstance.currentTab.lines[parent].path == "Eat" {
                
                let trueIndex = indexPath.row - 1
                    
                lineitemCollectionCell.modNameLabel?.text = "\(TabManager.sharedInstance.currentTab.lines[parent].additions[trueIndex].values[0].name)"
                    
                if TabManager.sharedInstance.currentTab.lines[parent].additions[trueIndex].values[0].price != "0" {
                        
                    let modPrice = TabManager.sharedInstance.currentTab.lines[parent].additions[trueIndex].values[0].price
                    let lineQTY = TabManager.sharedInstance.currentTab.lines[parent].quantity
                        
                    let modTotalPrice = Int(modPrice)! * Int(lineQTY)
                        
                    lineitemCollectionCell.modPriceLabel?.text = "+ " + "\(modTotalPrice)"
                        
                } else {
                        lineitemCollectionCell.modPriceLabel?.text = ""
                }
                    
                        // ---------
                        // WARNING: value[0] is not dynamic and will error for multi-selections
                        // ---------
                    
            } else {
                // Do some Beer or Wine Stuff
            }
                    
            // Styles
            lineitemCollectionCell.backgroundColor = UIColor.whiteColor()
            lineitemCollectionCell.modNameLabel.font = UIFont.scriptFont(18)
            lineitemCollectionCell.modPriceLabel.font = UIFont.scriptFont(18)
                    
            return lineitemCollectionCell
           
            
        // Delivery or Take Away
        } else {
            let lineitemCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemCollectionCell", forIndexPath: indexPath) as! TabLineItemCollectionViewCell
                    
                    
            // Assignments
<<<<<<< HEAD
            if TabManager.sharedInstance.currentTab.lines[parent].type == "delivery" {
                lineitemCollectionCell.modNameLabel.text = "Dine In"
            } else if TabManager.sharedInstance.currentTab.lines[parent].type == "takeaway" {
                lineitemCollectionCell.modNameLabel.text = "Take Away"
            } else {
                lineitemCollectionCell.modNameLabel.text = ""
            }
            
=======
            lineitemCollectionCell.modNameLabel.text = TabManager.sharedInstance.currentTab.lines[parent].type.capitalizedString
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
            lineitemCollectionCell.modPriceLabel.text = ""
                    
                    
            // Styles
            lineitemCollectionCell.modNameLabel.font = UIFont.scriptFont(18)
            lineitemCollectionCell.backgroundColor = UIColor.whiteColor()
                    
                    
            return lineitemCollectionCell
                    
        }
    }
    
    
    // Size Collection Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        var collectionLineSize: CGSize!
            
        let cellWidth = collectionView.bounds.size.width - 10
        let cellHeight = CGFloat(20)
            
        collectionLineSize = CGSize(width: cellWidth, height: cellHeight)
            
        return collectionLineSize
            
    }
}

