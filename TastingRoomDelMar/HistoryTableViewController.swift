//
//  HistoryTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HistoryTableViewController: UITableViewController {

    var nav: UINavigationBar?

    var closedOrders = [PFObject]()
    var openOrders = [PFObject]()
    var unregisteredOrders = [PFObject]()
    var ascClosedOrders = [PFObject]()

    
    var rows: Int!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var orderToPass: PFObject!
    
    let formatter = PriceFormatManager.priceFormatManager

    
    // ----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.closedOrders.removeAll()
        self.openOrders.removeAll()
        self.unregisteredOrders.removeAll()
        
        self.orderQuery()

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "History"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToMenu(sender: AnyObject) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
        // Add Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = closedOrders.count
        
        return rows
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableCell", forIndexPath: indexPath) as! HistoryTableViewCell

        let order = ascClosedOrders[indexPath.row]
        
    
        let dateUpdated = order.createdAt
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d, h:mm a"
        
        
        // Assigments
        cell.orderNumberLabel.text = "Order #" + String(order["lightspeedId"])
        cell.dateLabel.text = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated!)) as String
        cell.typeLabel.text = order["type"] as? String
        
        let orderPrice = order["orderTaxInfo"][0]["totalWithTax"]! as! Double
        let totalString = formatter.formatPrice(orderPrice)
        cell.totalLabel.text = "Total: " + totalString
        
        cell.methodLabel.text = order["checkoutMethod"] as? String
        
        // Styles
        cell.orderNumberLabel.font = UIFont.headerFont(24)
        cell.dateLabel.font = UIFont.headerFont(16)
        cell.typeLabel.font = UIFont.headerFont(14)
        
        cell.totalLabel.font = UIFont.headerFont(28)
        cell.methodLabel.font = UIFont.headerFont(16)
        
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        orderToPass = ascClosedOrders[indexPath.row]
        
        
        self.performSegueWithIdentifier("historyDetail", sender: self)
        
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "historyDetail" {
            

            
            let vc = segue.destinationViewController as! HistoryDetailTableViewController
            
            
            print("+++++++++++++++")
            print("\(orderToPass)")
            print("+++++++++++++++")
            
            vc.order = orderToPass
            
        }

    }

    
    // Order Query
    func orderQuery() {
        
        let query:PFQuery = PFQuery(className:"Order")
        query.includeKey("orderItems")
        query.includeKey("lineItems")
        query.includeKey("orderTaxInfo")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                if printFlag {
                    print("-----------------------")
                    print("Order query retrieved \(objects!.count) objects.")
                }
                
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    if object["closed"] as? Bool == true {
                        
                        self.closedOrders.append(object)
                        
                    } else if object["closed"] as? Bool == false {
                    
                        self.openOrders.append(object)
                        
                    } else {
                        
                        self.unregisteredOrders.append(object)
                        
                    }
                    
                    self.ascClosedOrders = self.closedOrders.reverse()
                    
                }
                
                if printFlag {
                    print("\(self.closedOrders.count) orders are closed.")
                    print("\(self.openOrders.count) orders are open.")
                    print("\(self.unregisteredOrders.count) orders are unregistered.")
                    print("-----------------------")
                }
                
                AnimationManager.sharedInstance.animateTable(self.tableView)
                
            } else {
                
                // Log details of the failure
                if printFlag {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }
}
