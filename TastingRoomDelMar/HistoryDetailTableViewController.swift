//
//  HistoryDetailTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HistoryDetailTableViewController: UITableViewController {

    var order: PFObject!
    
    var rows = Int()
    var totalRow = Int()
    
    var lineItemNames = [String]()
    
    
    
    // ---------
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Order Passed: \(order)")

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HistoryDetailHeaderTableCell") as! HistoryDetailHeaderTableViewCell
        
        headerCell.itemLabel.font = UIFont.headerFont(18)
        headerCell.qtyLabel.font = UIFont.headerFont(18)
        headerCell.priceLabel.font = UIFont.headerFont(18)
        
        return headerCell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = order["lineItems"].count + 1
        totalRow = rows - 1
        
        print("\(order["lineItems"].count) line items found for this order.")
        
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()

        if indexPath.row < totalRow {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryDetailTableCell", forIndexPath: indexPath) as! HistoryDetailTableViewCell
            
            // Assignments
            cell.qtyLabel.text = String(order["orderItems"][indexPath.row]["amount"])
            cell.itemLabel.text = lineItemNames[indexPath.row]
            cell.priceLabel.text = String(order["orderItems"][indexPath.row]["totalPrice"])
            
            // Styles
            cell.qtyLabel.font = UIFont.headerFont(18)
            cell.itemLabel.font = UIFont.headerFont(20)
            cell.priceLabel.font = UIFont.headerFont(18)
            
            return cell
            
        } else if indexPath.row == totalRow {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("HistoryDetailTotalTableCell") as! HistoryDetailTotalTableViewCell
            
            let orderPrice = order["orderTaxInfo"][0]["totalWithTax"]! as! Double
            
            // Assigments
            cell.totalLabel.text = String(orderPrice)
            
            // Styles
            cell.total.font = UIFont.headerFont(28)
            cell.totalLabel.font = UIFont.headerFont(28)
            
            return cell
            
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
