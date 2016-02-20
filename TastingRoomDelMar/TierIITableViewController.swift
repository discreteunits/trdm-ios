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
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        // Items Indicator
        TabManager.sharedInstance.addItemsIndicator()

        // TIER 2 QUERY
        tierIIQuery()
        
        // FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self
        
        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = route[0]["name"] as! String
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
            
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< Del Mar", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "NexaRustScriptL-00", size: 20)!], forState: UIControlState.Normal)
            
        }
    }
    
// NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {

        route.removeAtIndex(0)
        for var index = 0; index < route.count; ++index {
            print("The Route has been decreased to: \(route[index]["name"]).")
        }
        print("-----------------------")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func openTab(sender: AnyObject) {
        
        TabManager.sharedInstance.removeItemsIndicator()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Tab")
        destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        destViewController.modalPresentationStyle = .CurrentContext
        
        let rootVC = sideMenuController() as! UIViewController
        rootVC.presentViewController(destViewController, animated: true, completion: nil)
        
        TabManager.sharedInstance.totalCellCalculator()
        
    }
    
// ------
// TIER 2 QUERY
// ------
    func tierIIQuery() {
        
        let query:PFQuery = PFQuery(className:"Tier2")
        query.includeKey("tag")
        // RESTRICT QUERY BASED ON TIER 1 SELECTION
        query.whereKey("tier1", equalTo: route[0])
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierII retrieved \(objects!.count) objects.")
                
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    if object["tag"]["state"] as! String == "active" {
                        
                        self.tierIIArray.append(object)
                        
                    }
                    
                }
                
                self.tableView.reloadData()
                for i in self.tierIIArray {
                    print("TierII Array: \(i["name"])")
                }
                print("-----------------------")
                
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
        cell.textLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 38.0)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let tableHeight = (tableView.bounds.size.height - 44.0)
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
 
        route.append(tierIIArray[indexPath.row])

        for var index = 0; index < route.count; ++index {
            print("The Route has been increased to: \(route[index]["name"]).")
        }
        print("-----------------------")
        
        self.performSegueWithIdentifier("tierIII", sender: self)
        
    }

}
