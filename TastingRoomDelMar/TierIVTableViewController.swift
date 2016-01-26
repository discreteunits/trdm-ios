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
    func tagsArrayCreation()
    func tierIVCollectionQuery()
    func tierIVTableQuery()
}

class TierIVTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var TierIVViewControllerRef: TierIVViewController?
    var TierIVCollectionViewControllerRef: TierIVCollectionViewController?
    
    var delegate: TierIVTableViewDelegate?
    
    var tierIVCollectionArray = [PFObject]()
    var tierIVTableArray = [PFObject]()
    
    var popover: UIPopoverController?
    
    var item: PFObject!
    
    var indexPath: NSIndexPath!


// ------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! TierIVTableViewCell

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.itemNameLabel?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
        cell.altNameLabel?.text = self.tierIVTableArray[indexPath.row]["alternateName"] as! String?
        
        dispatch_async(dispatch_get_main_queue()) {

            if let itemTags = self.tierIVTableArray[indexPath.row]["tags"] as? [PFObject] {

                for tagObject in itemTags {
                    
                    if self.tierIVCollectionArray.contains(tagObject) {

                        cell.varietalLabel?.text = tagObject["name"] as? String
                    
                    }
                
                }
            
            }
                
        }
        
// -------
// SET PRICE LABEL HERE
// -------
//
//        cell.pricingLabel?.text =
        
        return cell
    }
    
    
// SEGUE TRIGGER AND PREPARATION
    
    @IBAction func addToOrder(sender: AnyObject) {
        
        // ASSIGN ITEM TO OBJECT TO BE PASSED TO POPOVER
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TierIVTableViewCell {
                    indexPath = tableView.indexPathForCell(cell)
                }
            }
        }
        
        item = tierIVTableArray[indexPath.row]
        
        performSegueWithIdentifier("showItemConfig", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showItemConfig" {
            
            var vc = segue.destinationViewController as! PopoverViewController
            
            vc.popoverItem = item
            
            var controller = vc.popoverPresentationController
            
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
            
                controller?.delegate = self
                            
            }

        }
        
    }
    
    
// PRESENTATION CONTROLLER DATA SOURCE
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
