//
//  HistoryTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


class HistoryTableViewController: UITableViewController {

    var nav: UINavigationBar?

    var allOrders = [PFObject]()
    var closedOrders = [PFObject]()
    var openOrders = [PFObject]()
    var unregisteredOrders = [PFObject]()
    var ascClosedOrders = [PFObject]()

    
    var rows: Int!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var orderToPass: PFObject!
    
    let formatter = PriceFormatManager.priceFormatManager
    


    
    // ----------------------
    func defaultScreen() {
        
        // Default Empty History View
        
            let tabView = self.view
            // Screen Bounds
            let windowWidth = self.view.bounds.size.width
            let windowHeight = self.view.bounds.size.height
            // Create View
            let windowView = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
            windowView.backgroundColor = UIColor.whiteColor()
            windowView.layer.zPosition = 98
            // Create TRDM Logo
            let TRDMLogo = "secondary-logomark-03_rgb_600_600"
            let TRDMImage = UIImage(named: TRDMLogo)
            let TRDMImageView = UIImageView(image: TRDMImage)
            TRDMImageView.frame = CGRectMake(0, 0, windowWidth * 0.8, windowWidth * 0.8)
            TRDMImageView.frame.origin.y = windowHeight / 6
            TRDMImageView.frame.origin.x = windowWidth * 0.1
            TRDMImageView.alpha = 0.1
            TRDMImageView.layer.zPosition = 99
            // Create Message Text View
            let messageTextView = UITextView(frame: CGRectMake(0, 0, windowWidth * 0.7, windowWidth / 2))
            messageTextView.frame.origin.y = windowHeight * 0.65
            messageTextView.frame.origin.x = windowWidth * 0.15
            messageTextView.text = "Looks like you haven't placed any orders yet."
            messageTextView.font = UIFont.basicFont(16)
            messageTextView.textColor = UIColor.grayColor()
            messageTextView.backgroundColor = UIColor.clearColor()
            messageTextView.userInteractionEnabled = false
            messageTextView.textAlignment = .Center
            messageTextView.layer.zPosition = 99
            // Create Back To Menu Button
            let menuButton = UIButton(frame: CGRectMake(0, 0, windowWidth * 0.9, windowHeight / 10))
            menuButton.frame.origin.y = windowHeight * 0.75
            menuButton.frame.origin.x = windowWidth * 0.05
            menuButton.setTitle("Back to Menu", forState: .Normal)
            menuButton.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
            menuButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            menuButton.titleLabel?.font = UIFont.scriptFont(24)
            menuButton.layer.cornerRadius = 12.0
            menuButton.clipsToBounds = true
            menuButton.addTarget(self, action: #selector(TabViewController.backToMenu), forControlEvents: UIControlEvents.TouchUpInside)
            menuButton.layer.zPosition = 99

        
            // Add Created Views
            tabView.addSubview(windowView)
            tabView.addSubview(TRDMImageView)
            tabView.addSubview(messageTextView)
            tabView.addSubview(menuButton)
        
    }
    
    func backToMenu() {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
        // Add Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.closedOrders.removeAll()
        self.openOrders.removeAll()
        self.unregisteredOrders.removeAll()
        
        self.orderQuery()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
        
        
        tableView.tableFooterView = UIView()
        

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

        let order = allOrders[indexPath.row]
        
    
        let dateUpdated = order.createdAt
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d, h:mm a"
        
        
        // Assigments
        cell.orderNumberLabel.text = "Order #" + String(order["lightspeedId"])
        cell.dateLabel.text = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated!)) as String
        
        
        
        // Check Out Method Text Override
        if order["type"] as? String == "delivery" {
            cell.typeLabel.text = "Dine In"
        } else if order["type"] as? String == "takeaway" {
            cell.typeLabel.text = "Take Away"
        } else {
            cell.typeLabel.text = ""
        }
        
        

        
        print("---------------")
        print("\(order)")
        print("---------------")

        

        if order["orderTaxInfo"] != nil {
            cell.totalLabel.text = "Total: \(order["orderTaxInfo"][0]["totalWithTax"]!)"
        } else {
            cell.totalLabel.text = "Total: [error found]"

        }

        
        
        if order["closed"] as? Bool == true {
            cell.openCloseOrderLabel.text = "Closed"
        } else {
            cell.openCloseOrderLabel.text = "Open"
        }
        
        // Check Out Method Text Override
        if order["checkoutMethod"] as? String == "stripe" {
            cell.methodLabel.text = "Mobile App"
        } else if order["checkoutMethod"] as? String == "server" {
            cell.methodLabel.text = "Server"
        } else {
            cell.methodLabel.text = ""
        }
        
        
        // Styles
        cell.orderNumberLabel.font = UIFont.headerFont(24)
        cell.dateLabel.font = UIFont.headerFont(16)
        cell.typeLabel.font = UIFont.headerFont(14)
        
        cell.totalLabel.font = UIFont.headerFont(28)
        cell.openCloseOrderLabel.font = UIFont.headerFont(16)
        cell.methodLabel.font = UIFont.headerFont(14)
        
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        orderToPass = allOrders[indexPath.row]
        
        
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
        
        ActivityManager.sharedInstance.activityStart(self)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            ActivityManager.sharedInstance.activityStop(self)
            
            if error == nil {
                
                // The find succeeded.
                if printFlag {
                    print("-----------------------")
                    print("Order query retrieved \(objects!.count) objects.")
                }
                
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    self.allOrders.append(object)
                    
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
                
                if self.closedOrders.count == 0 {
                    self.defaultScreen()
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
