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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//
//        
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = TabManager.sharedInstance.currentTab.lines.count + 3
        totalRow = rows - 2
        actionRow = rows - 1
        
        return rows
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        // Line Item Table Row
        if indexPath.row == 0 && indexPath.row < totalRow {
            
            var lineitemCell: TabLineItemTableViewCell
            lineitemCell = tableView.dequeueReusableCellWithIdentifier("TabLineItemTableCell", forIndexPath: indexPath) as! TabLineItemTableViewCell
  
            
            lineitemCell.itemNameLabel?.text = tab.lines[indexPath.row].name as! String
            
            // Declare Pair for Presentation
            let orderMod = tab.lines[indexPath.row].modifiers[indexPath.row].name as! String
            let servingPrice = tab.lines[indexPath.row].price as! String
            var orderAndServing = orderMod + " " + servingPrice
            lineitemCell.orderModLabel?.text = "\(orderAndServing)"

            lineitemCell.qtyLabel?.text = tab.lines[indexPath.row].quantity as! String
            lineitemCell.priceLabel?.text = tab.lines[indexPath.row].price as! String
            
            return lineitemCell

        
        } else if indexPath.row == totalRow {
            
            var totalCell: TabTotalTableViewCell
            totalCell = tableView.dequeueReusableCellWithIdentifier("TabTotalTableCell", forIndexPath: indexPath) as! TabTotalTableViewCell
            
//            totalCell.subtotalLabel?.text == tab.
            
            
            return totalCell

            
        } else if indexPath.row == actionRow {
            
            var actionCell: TabActionTableViewCell
            
            actionCell = tableView.dequeueReusableCellWithIdentifier("TabActionTableCell", forIndexPath: indexPath) as! TabActionTableViewCell
            
            
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
