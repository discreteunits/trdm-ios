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
    func recalculateTotals() 
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
    override func viewWillAppear(animated: Bool) {

        self.tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        if TabManager.sharedInstance.currentTab.lines.count > 0 {
            // Scroll to bottom of table
            dispatch_async(dispatch_get_main_queue()) {
                let indexPath = NSIndexPath(forRow: TabManager.sharedInstance.currentTab.lines.count - 1, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
            }
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = TabManager.sharedInstance.currentTab.lines.count
        
        return rows
        
    }
    
    
    func makeAttributedString(tab: Tab, index: Int) -> NSAttributedString {

        let lineItem = tab.lines[index]

        // just a single product - merch, events, flights, bottles
        // a subproduct of a product - beer and wine, and more
        // additions to products - harvest
        
        let nameAttributes = [NSFontAttributeName: UIFont.headerFont(24)]
        let subNameAttributes = [NSFontAttributeName: UIFont.basicFont(16)]
        let typeAttributes = [NSFontAttributeName: UIFont.basicFont(12)]
        
        
        let nameString = NSMutableAttributedString(string: "\(lineItem.name)\n", attributes: nameAttributes)
        
        if lineItem.path == "Drink" {
            // Get Subproduct Name
            let subNameString = NSAttributedString(string: "\(lineItem.subproduct.name)\n", attributes: subNameAttributes)
            nameString.appendAttributedString(subNameString)

        } else if lineItem.path == "Eat" {
            // Get Each Addition Name
            for addition in lineItem.additions {
                let additionNameString = NSAttributedString(string: "\(addition.name)\n")
                nameString.appendAttributedString(additionNameString)
            }
        }
        
        // Get Delivery or Take Away Text
        let typeString = NSAttributedString(string: "\(lineItem.type)", attributes: typeAttributes)
        nameString.appendAttributedString(typeString)
        
        
        return nameString
        
        
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var lineitemCell: TabLineItemTableViewCell
        lineitemCell = tableView.dequeueReusableCellWithIdentifier("TabLineItemTableCell", forIndexPath: indexPath) as! TabLineItemTableViewCell
  
        // Connect Specific Table Cell With Specific Colleciton View
        lineitemCell.contentView.tag = indexPath.row
        
        lineitemCell.quantityLabel.text = "\(TabManager.sharedInstance.currentTab.lines[indexPath.row].quantity)"
        lineitemCell.contentDataLabel?.attributedText = makeAttributedString(TabManager.sharedInstance.currentTab, index: indexPath.row)
        
        let price = TabManager.sharedInstance.currentTab.lines[indexPath.row].price
        let convertedPrice = formatter.formatPrice(price)
        lineitemCell.priceLabel.text = convertedPrice

        
        return lineitemCell

    }
    
    

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
        
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
            
            
            if TabManager.sharedInstance.currentTab.lines.count == 0 {
                self.dismissViewControllerAnimated(false, completion: nil)
            }


        }
        
        // Trigger Function in Floating Table File To Reload
        delegate?.recalculateTotals()
        
        
        self.tableView.endUpdates()

        TabManager.sharedInstance.totalCellCalculator()

        self.tableView.reloadData()

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // This Controller Does Not Segue
        
    }
}