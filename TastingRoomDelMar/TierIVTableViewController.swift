//
//  TierIVTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/13/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class TierIVTableViewController: UITableViewController {

    var itemsArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemsQuery()
        
        self.tableView.reloadData()

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
        return itemsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell

        cell.itemNameLabel?.text = itemsArray[indexPath.row]["name"] as! String?
        cell.altNameLabel?.text = itemsArray[indexPath.row]["alternateName"] as! String?
        
        
        
       cell.varietalLabel?.text = itemsArray[indexPath.row]["winevarietal"].name as String?
        //        cell.pricingLabel?.text = itemsArray[indexPath.row].mg["modifierIds"[1]] as! Int?     query.whereKey("arrayKey", equalTo: 2)


        return cell
    }
 
// -----------
// QUERY
// -----------
    func itemsQuery() {
        
        /*
        
        var varietalQuery = PFQuery(className: ** ITEMS ** )
        varietalQuery.whereKey( ** TYPE **, equalTo: ** PASS IN TIER IV COLLECTION SELECTION ** )
        
        var itemsQuery = PFQuery(className: "Tags")
        
        itemsQuery.includeKey("name")
        itemsQuery.whereKey("WineVarietal", matchesQuery: varietalQuery)
        
        */

        
        let query:PFQuery = PFQuery(className:"Items")
            query.includeKey("mg.winevarietals")
    
    
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
    
            if error == nil {
    
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
    
                // Do something with the found objects
                for object in objects! as [PFObject] {
                    
                    if object["tag"]["state"] as! String == "active" {
                        
                        print(object["tag"]["state"])
                        self.itemsArray.append(object as PFObject!)
                        
                    }
    
                }
    
                self.tableView.reloadData()
                print("The ITEMS ARRAY equals: \(self.itemsArray)")
    
            } else {
    
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
    
            }
        }
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
