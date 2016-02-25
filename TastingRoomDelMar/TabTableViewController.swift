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
    
}

class TabTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {

    // Table Cell Row Indicators
    var rows: Int!
    var totalRow: Int!
    var actionRow: Int!

    var tab = TabManager.sharedInstance.currentTab

    @IBOutlet var tabTableView: UITableView!
    
    var TableNumberViewControllerRef: TableNumberViewController?
    
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

        rows = calculateRows()
        
        return rows
        
    }
    
    func calculateRows() -> Int {
        let numberOfRows = TabManager.sharedInstance.currentTab.lines.count + 2
        totalRow = numberOfRows - 2
        actionRow = numberOfRows - 1
        
        return numberOfRows
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        // Line Item Table Row
        if indexPath.row < totalRow {
            
            var lineitemCell: TabLineItemTableViewCell
            lineitemCell = tableView.dequeueReusableCellWithIdentifier("TabLineItemTableCell", forIndexPath: indexPath) as! TabLineItemTableViewCell
  
            // Connect Specific Table Cell With Specific Colleciton View
            lineitemCell.contentView.tag = indexPath.row
            
            // Assignments
            lineitemCell.itemNameLabel?.text = "\(tab.lines[indexPath.row].name)"
            
            // Styles
            lineitemCell.itemNameLabel.font = UIFont.headerFont(24)

            
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
            totalCell.subtotalLabel.font = UIFont.headerFont(18)
            totalCell.taxLabel.font = UIFont.headerFont(18)
            totalCell.totalLabel.font = UIFont.headerFont(18)
            
            totalCell.subtotalValueLabel.font = UIFont.scriptFont(18)
            totalCell.taxValueLabel.font = UIFont.scriptFont(18)
            totalCell.totalValueLabel.font = UIFont.scriptFont(18)
            
            
            return totalCell

            
        // Action Table Row
        } else if indexPath.row == actionRow {
            
            var actionCell: TabActionTableViewCell
            
            actionCell = tableView.dequeueReusableCellWithIdentifier("TabActionTableCell", forIndexPath: indexPath) as! TabActionTableViewCell

            // Styles
            actionCell.placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
            actionCell.placeOrderButton.titleLabel?.font = UIFont.scriptFont(28)
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
            
            let tableViewCell = UITableViewCell()
            
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
        
        let cellSize = CGFloat()

        if indexPath.row < totalRow {
            if tab.lines.count > 0 {
                let lineMods = tab.lines[indexPath.row].modifiers.count
                let lineSize = lineMods * 25 + 50
            
                return CGFloat(lineSize)
            }
            
            return 0
            
        } else if indexPath.row == totalRow {
            
            return 100
            
        } else if indexPath.row == actionRow {

            return 100
            
        }
        
        return cellSize

    }

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

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            tableView.beginUpdates()
            
            TabManager.sharedInstance.currentTab.lines.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths(NSArray(object: NSIndexPath(forRow: indexPath.row, inSection: 0)) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Left)

            tableView.endUpdates()

            
            self.tableView.reloadData()

        }
        
        rows = calculateRows()
        TabManager.sharedInstance.totalCellCalculator()

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get Screen Size
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        
        // Enter Table Number Popover
        if segue.identifier == "enterTableNumber" {
            
            let vc = segue.destinationViewController as! TableNumberViewController
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight*0.4)
            
            // Data To Be Passed
            
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller?.delegate = self
            }
            
            // Protocol or GratuitySegue
            self.TableNumberViewControllerRef = vc
            vc.delegate = self
            
        }
        
        // Add Gratuity Popover
        if segue.identifier == "addGratuity" {
            let vc = segue.destinationViewController as! AddGratuityViewController
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight * 0.53)
            
            // Data To Be Passed
            
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller?.delegate = self
            }
            
        }
        
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

}


// Extension for protocol in Table Number Popover
extension TabTableViewController: TableNumberViewDelegate {
    
    func gratuitySegue() {
        performSegueWithIdentifier("addGratuity", sender: self)
    }
    
}


// Mark: Collection Data Source
extension TabTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let parent = collectionView.superview!.tag
        var numberOfItems: Int!

        if parent < totalRow {
            
            let modChoices = TabManager.sharedInstance.currentTab.lines[0].modifiers.count
            numberOfItems = modChoices
            
        }
        
        return numberOfItems
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        let parent = collectionView.superview!.tag
        
        if parent < totalRow {
            
            // Serving Modifier Collection Row
            if indexPath.row == 0 {
                
                let lineitemServingCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemServingCollectionCell", forIndexPath: indexPath) as! TabLineItemServingCollectionViewCell

                // Assignments
                //// Declare Pair for Presentation
                let orderMod = TabManager.sharedInstance.currentTab.lines[parent].modifiers[indexPath.row].name
                let servingPrice = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].modifiers[indexPath.row].price))"
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
                
                
            // All Other Modifier Colleciton Rows
            } else {
               
                let lineitemCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemCollectionCell", forIndexPath: indexPath) as! TabLineItemCollectionViewCell
                
                // Assignment
                lineitemCollectionCell.modNameLabel?.text = "\(TabManager.sharedInstance.currentTab.lines[parent].modifiers[indexPath.row].name)"
                
                // Styles
                lineitemCollectionCell.backgroundColor = UIColor.whiteColor()
                lineitemCollectionCell.modNameLabel.font = UIFont.scriptFont(18)
                
                return lineitemCollectionCell
                
            }
            
        }
        
        return cell
        
    }
    
    
    // Size Collection Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSize =  CGSize()
        let parent = collectionView.superview!.tag
        
        if parent < totalRow {

            var collectionLineSize: CGSize!
            
            let cellWidth = collectionView.bounds.size.width - 10
            let cellHeight = CGFloat(25)
            
            collectionLineSize = CGSize(width: cellWidth, height: cellHeight)
            
            return collectionLineSize
            
        } else if parent == totalRow {
            
            // Do nothing
            
        } else if parent == actionRow {
            
            // Do nothing
            
        }
        
        return cellSize
        
    }
    
    
    // CLOUDCODE PLACEORDER
    @IBAction func placeOrder(sender: AnyObject) {
        
        // Checkout Options
        if TabManager.sharedInstance.currentTab.checkoutMethod == "" {
        
            AlertManager.sharedInstance.checkoutOptions(self, title: "Checkout Options", message: "Please select your desired checkout method below.")
            
        // If User already selected checkout option of stripe
        } else if TabManager.sharedInstance.currentTab.checkoutMethod == "stripe" {
            
            AlertManager.sharedInstance.stripeCheckout(self)
            
        }

    }
    
}
