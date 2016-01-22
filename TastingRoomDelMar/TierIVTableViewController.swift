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

@objc
protocol TierIVTableViewDelegate {
    func tierIVCollectionQuery()
    func tierIVTableQuery()
}

class TierIVTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var tierIVTableArray = [PFObject]()
    
    var tableContainerViewController: TierIVViewController?
    
    var TierIVViewControllerRef: TierIVViewController?
    
    var delegate: TierIVTableViewDelegate?
    
    var popover: UIPopoverController?
    
// ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TierIV table view has recieved: \(tierIVTableArray)")

        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
// PREPARE FOR SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "itemConfigPopover" {
            
            let vc = segue.destinationViewController as! UIViewController
            
            let controller = vc.popoverPresentationController
            
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                
                controller?.delegate = self
                
            }
            
        }
        
    }
    
// POPOVER DATA SOURCE
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
        
    }

// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tierIVTableArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell

        cell.itemNameLabel?.text = tierIVTableArray[indexPath.row]["name"] as! String?
        cell.altNameLabel?.text = tierIVTableArray[indexPath.row]["alternateName"] as! String?
        
//       cell.varietalLabel?.text = route[2]["name"] as? String

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("itemConfigPopover", sender: self)

    }

}
