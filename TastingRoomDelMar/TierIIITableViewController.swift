//
//  TierIIITableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/12/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


class TierIIITableViewController: UITableViewController, ENSideMenuDelegate {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var tierIIIArray = [PFObject]()
    
    var nav: UINavigationBar?
    
    // --------------------
    override func viewWillDisappear(animated: Bool) {
        
        // Stop Activity Indicator
        ActivityManager.sharedInstance.activityStop(self)
        
        tableView.reloadData()
        
//        AnimationManager.sharedInstance.fade(self.tableView, alpha: 0.0)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        AnimationManager.sharedInstance.fade(self.tableView, alpha: 1.0)
        
        self.tierIIIArray.removeAll()
        
        self.tierIIIQuery()
        
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
            
            navigationTitle.title = RouteManager.sharedInstance.TierTwo!["name"] as? String
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            let lastWindow = RouteManager.sharedInstance.TierOne!["name"] as! String
            
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< \(lastWindow)", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TierIIITableViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "NexaRustScriptL-00", size: 20)!], forState: UIControlState.Normal)
            
        }
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {

        // Remove
        RouteManager.sharedInstance.TierTwo = nil
        
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
    
    // TIER 3 QUERY
    func tierIIIQuery() {
        
        let query:PFQuery = PFQuery(className:"Tier3")
        query.includeKey("category")
        query.orderByAscending("sortOrder")
        
        
//        query.whereKey("parentTiers", equalTo: RouteManager.sharedInstance.TierTwo!)
        query.whereKey("parentTiers", containedIn: RouteManager.sharedInstance.Route!)
        
        
        ActivityManager.sharedInstance.activityStart(self)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            ActivityManager.sharedInstance.activityStop(self)
            
            if error == nil {
   
                // The find succeeded.
                print("TierIII retrieved \(objects!.count) objects.")
                
                for object in objects! as [PFObject]! {
                    
                    if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                        
                        if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                            
                            if object["name"] as! String == "Water" {
                                self.tierIIIArray.append(object)
                            }
                            
                        } else {
                        
                            if object["name"] as! String == "Flights" || object["name"] as! String == "Draft" {
                                print("Not showing Flights or Drafts due to Take Away")
                            } else {
                                
                                if let product = object["category"] as? PFObject {
                                    
                                    if product["state"] as! String == "active" {
                                        self.tierIIIArray.append(object)
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    } else {
                        
                        if let product = object["category"] as? PFObject {
                            if product["state"] as! String == "active" {
                                
                                self.tierIIIArray.append(object)
                                
                            }
                        }
                        
                    }
                    
                    

                    
                    
                    
                }
                                
                for i in self.tierIIIArray {
                    print("TierIII Array: \(i["name"])")
                }
                print("-----------------------")
                
                
//                AnimationManager.sharedInstance.animateTable(self.tableView)

                self.tableView.reloadData()

            } else {
                
                // Log details of the failure
                if printFlag {
                    print("Error: \(error!) \(error!.userInfo)")
                }
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
        return tierIIIArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tierIIIArray[indexPath.row]["name"] as? String
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
        let numberOfCells: Int = tierIIIArray.count
        let numberOfCellsFloat = CGFloat(numberOfCells)
        let cellHeight = tableHeight / numberOfCellsFloat
        
        return cellHeight
        
    }
    
    // FLYOUT TRIGGER
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        // Start Activity Indicator
        ActivityManager.sharedInstance.activityStart(self)
        
        // ROUTE MANAGER
        RouteManager.sharedInstance.TierThree = tierIIIArray[indexPath.row]
        RouteManager.sharedInstance.printRoute()
        
        self.performSegueWithIdentifier("tierIV", sender: self)
        
    }
}
