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
    func opaqueWindow()
}

class TierIVTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var TierIVViewControllerRef: TierIVViewController?
    var TierIVCollectionViewControllerRef: TierIVCollectionViewController?
    
    @IBOutlet weak var addToTabButton: UIButton!
    
    var delegate: TierIVTableViewDelegate?
    
    var tierIVCollectionArray = [PFObject]()
    var tierIVTableArray = [PFObject]()

    var popover: UIPopoverController?
    
    var item: PFObject!
    var itemVarietal: PFObject!
    
    var indexPath: NSIndexPath!
    
    var popoverHeight: CGFloat!
    var popoverWidth: CGFloat!
    
    var itemTaxRates = [PFObject]()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var heights = [CGFloat]()
    var largestHeight = CGFloat()
    
    // Collect Subgroups
    var subGroups = [PFObject]()


// ---------------------
    
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

        
        cell.addToOrderButton.layer.cornerRadius = 6.0
        cell.addToOrderButton.clipsToBounds = true
        
        
        cell.itemNameLabel?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
        cell.itemNameLabel?.font = UIFont.headerFont(24)
        cell.altNameTextView?.text = self.tierIVTableArray[indexPath.row]["info"] as! String?
        cell.altNameTextView?.font = UIFont.basicFont(16)

// -------------------------------
        // Adjustment For Text View Text Wrapping

        
        cell.altNameTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.altNameTextView.contentInset = UIEdgeInsets(top: -10,left: -5,bottom: 0,right: 0)
        
        cell.altNameTextView?.sizeToFit()
        
        let textViewHeight = cell.altNameTextView.contentSize.height
        

        cell.altNameTextView.scrollEnabled = false
        

        heights.append(textViewHeight)
        largestHeight = heights.maxElement()!

// ---------------------------------

        
        // Prices FOUND in Item Table
        if let itemPrice = self.tierIVTableArray[indexPath.row]["prices"] {
            cell.pricingLabel?.text = self.tierIVTableArray[indexPath.row]["prices"] as! String
            cell.pricingLabel?.font = UIFont(name: "OpenSans", size: 12)
        
            // Prices NOT Found in Item Table
        } else {
            cell.pricingLabel?.text = ""
        }
        

        
        dispatch_async(dispatch_get_main_queue()) {
            
            print("item categories: \(self.tierIVTableArray[indexPath.row]["categories"])")

            if let itemCategories = self.tierIVTableArray[indexPath.row]["categories"] as? [PFObject] {

                for categoryObject in itemCategories {
                    
                    if self.tierIVCollectionArray.contains(categoryObject) {

                        cell.varietalLabel?.text = categoryObject["name"] as? String
                        cell.varietalLabel?.font = UIFont(name: "OpenSans", size: 16)
                        
                        self.itemVarietal = categoryObject as PFObject!

                    }
                    
                }
            
            }
            
        }
        
        if cell.varietalLabel.text == "Varietal" {
            cell.varietalLabel.text = ""
        }
        
        return cell
        
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cellHeight = 60 + largestHeight
        
        return cellHeight
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)! as! TierIVTableViewCell
        
        item = tierIVTableArray[indexPath.row]

        // If product has additions
        if let additions = tierIVTableArray[indexPath.row]["additions"] {
            
            print("************************************")
            print("ADDITIONS: \(additions)")
            print("************************************")
            
            for addition in additions as! [PFObject] {
                subGroups.append(addition)
            }
            
        }

        
        
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        print("------------------------")

    }
    
    
// SEGUE TRIGGER AND PREPARATION
    @IBAction func addToOrder(sender: AnyObject) {
        
        addToOrderButton(sender)
        
    }
    
    func addToOrderButton(sender: AnyObject) {
        
        
        // ASSIGN ITEM TO OBJECT TO BE PASSED TO POPOVER - To Select Button
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TierIVTableViewCell {
                    
                    indexPath = tableView.indexPathForCell(cell)
                    item = tierIVTableArray[indexPath.row]
                    
                    // If product has additions
                    if let additions = tierIVTableArray[indexPath.row]["additions"] {
                    
                        print("************************************")
                        print("ADDITIONS: \(additions)")
                        print("************************************")
                    
                        for addition in additions as! [PFObject] {
                            subGroups.append(addition)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
   
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        print("------------------------")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showItemConfig" {
            
            let vc = segue.destinationViewController as! PopoverViewController
            
            // Dynamically assign Popover Window Size
            
            let popoverDynamicHeight = subGroups.count
            let popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
            popoverHeight = CGFloat(popoverHeightCalculation)
            popoverWidth = tableView.bounds.size.width
            vc.preferredContentSize = CGSizeMake(popoverWidth, popoverHeight)

            
            AnimationManager.sharedInstance.opaqueWindow(self)
            
            // Data to be passed to popover
            vc.popoverItem = item
            vc.popoverItemVarietal = itemVarietal
            vc.subproducts = subproductQuery(item.objectId!)
            
            // If there are additions
            if subGroups != [] {
                vc.subGroups = subGroups
            }
            
            
            var controller = vc.popoverPresentationController
            
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            
            if controller != nil {
            
                controller?.delegate = self
                            
            }
            
            activityStop()

        }
        
    }
    
    
// PRESENTATION CONTROLLER DATA SOURCE
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
       
        delegate?.opaqueWindow()
        
        print("Popover closed.")
        
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    // SUBPRODUCT QUERY
    func subproductQuery(parentId: String) -> [PFObject] {
        
        let subproductsArray: [PFObject]?
        
        let query:PFQuery = PFQuery(className: "Product")
        query.whereKey("productType", equalTo: parentId)
        
        do {
            subproductsArray = try query.findObjects() as [PFObject]
        } catch _ {
            subproductsArray = nil
        }
        
        print("Subproducts array: \(subproductsArray)")
        
        return subproductsArray!
        
    }
    
    
//    // MODIFIER  QUERY
//    func modifierQuery(modifierGroupObject: PFObject) -> [PFObject] {
//        
//        let modArray: [PFObject]?
//        
//        let modifierGroupId = modifierGroupObject["cloverId"] as? String
//        
//        let modifierQuery:PFQuery = PFQuery(className: "Modifier")
//        modifierQuery.whereKey("modifierGroupId", containsString: modifierGroupId)
//        modifierQuery.orderByAscending("price")
//
//            // Synchronously Return Modifiers
//            do {
//                modArray = try modifierQuery.findObjects() as [PFObject]
//            } catch _ {
//                modArray = nil
//            }
//            
//            print("Queried modifier group: \(modifierGroupObject["name"])")
//
//            return modArray!
//            
//    }
    
    
    
    
    // ACTIVITY START FUNCTION
    func activityStart() {
        activityIndicator.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        view.addSubview(activityIndicator)
    }
    
    // ACTIVITY STOP FUNCTION
    func activityStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
}
