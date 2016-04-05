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
    
    var nav: UINavigationBar?
    

    @IBOutlet weak var navigationTitle: UINavigationItem!

    
    // ---------
    override func viewWillAppear(animated: Bool) {
        
        orderLineItemQuery(order)
        print("Line Item Names: \(lineItemNames)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "Order #" + String(order["lightspeedId"])
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< History", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "NexaRustScriptL-00", size: 20)!], forState: UIControlState.Normal)
        
        }

    }

    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

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
        
        return rows
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()

        if indexPath.row < totalRow {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryDetailTableCell", forIndexPath: indexPath) as! HistoryDetailTableViewCell
            
            // Assignments
            cell.qtyLabel.text = String(order["orderItems"][indexPath.row]["amount"] as! Int)
            cell.itemLabel.text = lineItemNames[indexPath.row]
            cell.priceLabel.text = String(order["orderItems"][indexPath.row]["totalPrice"] as! Double)
            
            // Styles
            cell.qtyLabel.font = UIFont.headerFont(18)
            cell.itemLabel.font = UIFont.headerFont(28)
            cell.priceLabel.font = UIFont.headerFont(18)
            
            // Functionality
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
            
            
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

    
//    // Order Query
//    func orderLineItemQuery(orderToPass: PFObject)  {
//        
//        
//        var lineItemObjectIds = [Int]()
//        
//        for lineItem in orderToPass["orderItems"] as! [AnyObject] {
//            lineItemObjectIds.append(lineItem["productId"]! as! Int)
//        }
//        
//        print("lineItemObjectIds: \(lineItemObjectIds)")
//        
//        
//        
//        let query:PFQuery = PFQuery(className:"Product")
////        query.includeKey("lightspeedId")
//        query.whereKey("lightspeedId", containedIn: lineItemObjectIds)
//        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                
//                // The find succeeded.
//                if printFlag {
//                    print("-----------------------")
//                    print("Order LineItem query retrieved \(objects!.count) objects.")
//                }
//                
//                // Do something with the found objects
//                for object in objects! as [PFObject]! {
//                    
//                    let objectName = object["name"] as! String
//                    
//                    print("ObjectName in query: \(objectName)")
//                    
//                    self.lineItemNames.append(objectName)
//                    
//                }
//                
//                if printFlag {
//                    print("\(self.lineItemNames).")
//                    print("-----------------------")
//                }
//                
//            } else {
//                
//                // Log details of the failure
//                if printFlag {
//                    print("Error: \(error!) \(error!.userInfo)")
//                }
//                
//            }
//            
//        }
//        
//    }

    
    
    // Order Query
    func orderLineItemQuery(orderToPass: PFObject)  {
        
        
        var orderItemObjectIds = [Int]()
        
        for orderItem in orderToPass["orderItems"] as! [AnyObject] {
            orderItemObjectIds.append(orderItem["productId"]! as! Int)
        }
        
        print("lineItemObjectIds: \(orderItemObjectIds)")
        
        var products: [PFObject]?
        
        let query:PFQuery = PFQuery(className:"Product")
        //        query.includeKey("lightspeedId")
        query.whereKey("lightspeedId", containedIn: orderItemObjectIds)
        
        do {
            products = try query.findObjects() as [PFObject]
        } catch _ {
            products = nil
        }
        
        for product in products! {
            
            lineItemNames.append(product["name"] as! String)
            
        }
        
        print("Query completed, creating: \(lineItemNames)")
        
    }
    
}
