//
//  TierITableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/12/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse

var route = [PFObject]()

class TierITableViewController: UITableViewController, ENSideMenuDelegate {

    var tierIArray = [PFObject]()
    
    var nav: UINavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// TIER 1 QUERY
        tierIQuery()

// FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self

// NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "primary-logotype-05_rgb_600_600")
            imageView.image = image
            navigationItem.titleView = imageView
            
// RESET ROUTE
            route = []
            
        }
        
    }
// -----
// TIER 1 QUERY
// -----
    func tierIQuery() {
        
        let query:PFQuery = PFQuery(className:"Tier1")
        query.includeKey("tag")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierI retrieved \(objects!.count) objects.")
                
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    if object["tag"]["state"] as! String == "active" {
                        
                        print("\(object["tag"]["state"])")
                        self.tierIArray.append(object)
                        
                    }
                    
                }
                
                self.tableView.reloadData()
                print("TIERI ARRAY: \(self.tierIArray)")
                
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
        return tierIArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tierIArray[indexPath.row]["name"] as? String
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 38.0)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let tableHeight = (tableView.bounds.size.height - 44.0)
        let numberOfCells: Int = tierIArray.count
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
        
        route.append(tierIArray[indexPath.row])
        print("THE ROUTE HAS BEEN ADDED TO: \(route)")
        
        self.performSegueWithIdentifier("tierII", sender: self)

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
