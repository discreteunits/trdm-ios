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
    let tab = TabManager.sharedInstance.currentTab
    
    // Protocol Delegate
    var TabViewControllerRef: TabViewController?
    var delegate: TabTableViewDelegate?
    
    
    var containerViewController: TabViewController?

    
    
// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true

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
  
            
            
            // Assignments
            lineitemCell.itemNameLabel?.text = "\(tab.lines[indexPath.row].name)" // convert to int
            
                // Declare Pair for Presentation
            let orderMod = tab.lines[indexPath.row].modifiers[indexPath.row].name
            let servingPrice = "\(tab.lines[indexPath.row].modifiers[indexPath.row].price)" // convert to int
            let orderAndServing = orderMod + " " + servingPrice
            lineitemCell.orderModLabel?.text = "\(orderAndServing)"

            lineitemCell.qtyLabel?.text = "\(tab.lines[indexPath.row].quantity)" // convert to int
            lineitemCell.priceLabel?.text = "\(tab.lines[indexPath.row].price)" // convert to int
            
            // Styles
            lineitemCell.itemNameLabel.font = UIFont(name: "BebasNeueRegular", size: 24)
            lineitemCell.orderModLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            lineitemCell.qtyLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            lineitemCell.priceLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)

            
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
