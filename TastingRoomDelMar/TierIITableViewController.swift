//
//  TierIITableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/12/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class TierIITableViewController: UITableViewController, ENSideMenuDelegate {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var tierIIArray = [PFObject]()
    
    var nav: UINavigationBar?
    
    // ------------
    override func viewWillDisappear(animated: Bool) {
        
        // Stop Activity Indicator
        ActivityManager.sharedInstance.activityStop(self)

        
//        AnimationManager.sharedInstance.fade(self.tableView, alpha: 0.0)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        AnimationManager.sharedInstance.fade(self.tableView, alpha: 1.0)
        
        self.tierIIArray.removeAll()
        
        self.tierIIQuery()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Items Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
        // FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self
        
        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = RouteManager.sharedInstance.TierOne!["name"] as? String
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< Del Mar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TierIITableViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont.scriptFont(20)], forState: UIControlState.Normal)
            
        }
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        // Remove
        RouteManager.sharedInstance.TierOne = nil
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func openTab(sender: AnyObject) {
        
        TabManager.sharedInstance.removeItemsIndicator()
        
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabStoryboard",bundle: nil)
        var destViewController : UIViewController
        
        destViewController = tabStoryboard.instantiateViewControllerWithIdentifier("Tab")
        destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        destViewController.modalPresentationStyle = .CurrentContext
        
        let rootVC = sideMenuController() as! UIViewController
        rootVC.presentViewController(destViewController, animated: true, completion: nil)
        
        TabManager.sharedInstance.totalCellCalculator()
        
    }
    
    // TIER 2 QUERY
    func tierIIQuery() {
        
        let query:PFQuery = PFQuery(className:"Tier2")
        query.includeKey("category")
        query.orderByAscending("sortOrder")
        query.whereKey("parentTiers", equalTo: RouteManager.sharedInstance.TierOne!)
        
        if offlineFlag == true {
            query.fromLocalDatastore()
        }
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierII retrieved \(objects!.count) objects.")
                
                for object in objects! as [PFObject]! {
                    if let product = object["category"] as? PFObject {
                        if product["state"] as! String == "active" {
                        
                            self.tierIIArray.append(object)
                            
                            var tierIIObject = PFObject(className: "TierII")
                            tierIIObject = object
                            
                            print("TierII Object Pinned Locally: \(tierIIObject["name"])")
                            
                            tierIIObject.pinInBackground()
                        
                        }
                    }
                }
                
                for i in self.tierIIArray {
                    print("TierII Array: \(i["name"])")
                }
                print("-----------------------")
                
//                AnimationManager.sharedInstance.animateTable(self.tableView)

                self.tableView.reloadData()

                
            } else {
                                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
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
        // #warning Incomplete implementation, return the number of rows
        return tierIIArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = tierIIArray[indexPath.row]["name"] as? String
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont.scriptFont(38)
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 0.4).CGColor
        border.frame = CGRect(x: 0, y: cell.frame.size.height - 1, width:  tableView.frame.size.width, height: 1)
        
        border.borderWidth = width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let tableHeight = (tableView.bounds.size.height)
        let numberOfCells: Int = tierIIArray.count
        let numberOfCellsFloat = CGFloat(numberOfCells)
        let cellHeight = tableHeight / numberOfCellsFloat
        
        return cellHeight
    }

    // FLYOUT TRIGGER
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // ADD INDEX TO ROUTE
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Start Activity Indicator
        ActivityManager.sharedInstance.activityStart(self)
        
        // ROUTE MANAGER
        RouteManager.sharedInstance.TierTwo = tierIIArray[indexPath.row]
        RouteManager.sharedInstance.printRoute()

        // Next Tier
        if tierIIArray[indexPath.row]["skipToTier4"] as! Bool {
            self.performSegueWithIdentifier("tierTwoToFour", sender: self)
        } else {
            self.performSegueWithIdentifier("tierIII", sender: self)
        }
    }
}
