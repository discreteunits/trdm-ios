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
    var lineItemObjects = [PFObject]()
    var chargedOrderItems = [[String:AnyObject]]()
    
    var nav: UINavigationBar?

    @IBOutlet weak var navigationTitle: UINavigationItem!

    // Price Formatter
    let formatter = PriceFormatManager.priceFormatManager
    
    // ---------
    override func viewWillAppear(animated: Bool) {
        
        orderLineItemQuery(order)
        print("Line Item Names: \(lineItemNames)")
        
        print("+++++++++++++++")
        print("\(lineItemNames)")
        print("+++++++++++++++")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView()
        
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "Order #" + String(order["lightspeedId"])
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< History", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryDetailTableViewController.back(_:)))
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

        
//        rows = order["lineItems"].count + 1
        
        rows = chargedOrderItems.count + 1
        totalRow = rows - 1
        

        
        return rows
        
    }

    func makeAttributedString(text:String) -> NSAttributedString {
        
        let textAttributes = [NSFontAttributeName: UIFont.headerFont(18)]
        
        let textString = NSMutableAttributedString(string: "\(text)", attributes: textAttributes)
        
        
        return textString
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()

        if indexPath.row < totalRow {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryDetailTableCell", forIndexPath: indexPath) as! HistoryDetailTableViewCell
            

            cell.qtyLabel.text = String(chargedOrderItems[indexPath.row]["amount"] as! Int)
            cell.itemLabel?.attributedText = makeAttributedString(lineItemObjects[indexPath.row]["name"] as! String)
            cell.priceLabel.text = "\(formatter.formatPrice(chargedOrderItems[indexPath.row]["totalPrice"] as! Double))"
            
        
            
            // Styles
            cell.qtyLabel.font = UIFont.headerFont(18)
            cell.priceLabel.font = UIFont.headerFont(18)
            
            // Functionality
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
            
            
            return cell
            
        } else if indexPath.row == totalRow {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("HistoryDetailTotalTableCell") as! HistoryDetailTotalTableViewCell
            
            let orderPrice = order["orderTaxInfo"][0]["totalWithTax"]! as! String
            
            // Assigments
            cell.totalLabel.text = orderPrice
            
            // Styles
            cell.total.font = UIFont.headerFont(28)
            cell.totalLabel.font = UIFont.headerFont(28)
            
            return cell
            
        }
        
        return cell
        
    }


    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    
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
        query.whereKey("productType", notEqualTo    : "CHOICE")
        query.whereKey("lightspeedId", containedIn: orderItemObjectIds)
        
        ActivityManager.sharedInstance.activityStart(self)
        
        do {
            ActivityManager.sharedInstance.activityStop(self)
            products = try query.findObjects() as [PFObject]
        } catch _ {
            ActivityManager.sharedInstance.activityStop(self)
            products = nil
        }
        
        for product in products! {
            
            lineItemObjects.append(product)
            
            
            for var i in 0..<order["orderItems"].count {
                let orderItems = order["orderItems"] as! [[String:AnyObject]]
                
                if orderItems[i]["productId"] as! Int == product["lightspeedId"] as! Int {
                    chargedOrderItems.append(orderItems[i])
                }
            }
            
        }
        
        
        
        print("Query completed, creating: \(lineItemNames)")
        
    }
    
}
