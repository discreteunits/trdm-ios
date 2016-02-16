//
//  PaymentTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PaymentTableViewController: UITableViewController {

    var currentCustomer = CardManager.sharedInstance.currentCustomer
    
    var rows = Int()
    
    // Table Row Indicators
    var addPaymentRow: Int!
    
    override func viewWillAppear(animated: Bool) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.getCards()
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        
        if currentCustomer.card.last4 != "" {
            rows = 2
        } else {
            rows = 1
        }
        
        addPaymentRow = rows - 1
        
        return rows
        
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        // Card Row
        if indexPath.row < addPaymentRow {
            let cardCell = tableView.dequeueReusableCellWithIdentifier("PaymentCardTableCell", forIndexPath: indexPath) as! PaymentCardTableViewCell
            
            // Assignments
            cardCell.providerLabel.text = currentCustomer.card.brand as! String
            cardCell.lastFourLabel.text = currentCustomer.card.last4
            
            
            // Styles
            cardCell.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
            cardCell.layer.borderWidth = 1.0
            cardCell.layer.borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).CGColor
            
            return cardCell
            
        // Add Payment Row
        } else if indexPath.row == addPaymentRow {
            let addCell = tableView.dequeueReusableCellWithIdentifier("PaymentAddCardTableCell", forIndexPath: indexPath)
            
            addCell.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
            addCell.layer.borderWidth = 1.0
            addCell.layer.borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).CGColor
            
            return addCell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Card Row
        if indexPath.row < addPaymentRow {
            
            // Edit Card
            
        // Add Payment Row
        } else if indexPath.row == addPaymentRow {

            performSegueWithIdentifier("addPayment", sender: self)
            
        }
        
    }
    
    
    // Get Card
    func getCards() {
        
        let card = CardManager.sharedInstance.fetchCards((PFUser.currentUser()?.objectId)!)

        
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
