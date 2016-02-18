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
    var modifierGroups = [PFObject]()
    
    var indexPath: NSIndexPath!
    
    var popoverHeight: CGFloat!
    var popoverWidth: CGFloat!

    var modDict = [[PFObject]]()
    
    var itemTaxRates = [PFObject]()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()


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

        
        cell.addToOrderButton.layer.cornerRadius = 6.0
        cell.addToOrderButton.clipsToBounds = true
        
        
        cell.itemNameLabel?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
        cell.itemNameLabel?.font = UIFont(name: "BebasNeueRegular", size: 24)
        cell.altNameLabel?.text = self.tierIVTableArray[indexPath.row]["alternateName"] as! String?
        cell.altNameLabel?.font = UIFont(name: "OpenSans", size: 16)

        cell.pricingLabel?.font = UIFont(name: "OpenSans", size: 12)
        
        dispatch_async(dispatch_get_main_queue()) {
            

            
            if let itemTags = self.tierIVTableArray[indexPath.row]["tags"] as? [PFObject] {

                for tagObject in itemTags {
                    
                    if self.tierIVCollectionArray.contains(tagObject) {

                        cell.varietalLabel?.text = tagObject["name"] as? String
                        cell.varietalLabel?.font = UIFont(name: "OpenSans", size: 16)

                        print("tagObject: \(tagObject)")
                        
                        self.itemVarietal = tagObject as PFObject!

                    
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
        
        activityStart()
        
        // ASSIGN ITEM TO OBJECT TO BE PASSED TO POPOVER
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TierIVTableViewCell {
                    indexPath = tableView.indexPathForCell(cell)
                }
            }
        }
        
        item = tierIVTableArray[indexPath.row]
        
        let popoverDynamicHeight = item["modifierGroups"].count
        let popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
        popoverHeight = CGFloat(popoverHeightCalculation)
        popoverWidth = tableView.bounds.size.width
        
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        print("------------------------")

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        modifierGroups.removeAll()
        modDict.removeAll()
        
        if segue.identifier == "showItemConfig" {
            
            var vc = segue.destinationViewController as! PopoverViewController
            
            // Dynamically assign Popover Window Size
            vc.preferredContentSize = CGSizeMake(popoverWidth, popoverHeight)

            
            delegate?.opaqueWindow()
            
            
            // Build array of modifier groups based on item selection
            for modifierGroup in self.item["modifierGroups"] as! [PFObject]! {
                self.modifierGroups.append(modifierGroup)
                
                self.modDict.append(modifierQuery(modifierGroup))

            }
            
            // Build array of Tax Rates based on item selection
            let taxRates = item["taxRates"] as! [PFObject]
            for taxRate in taxRates {
                self.itemTaxRates.append(taxRate)
            }
            print("\(taxRates.count) item tax rate(s) collected")
            
            
            // Data to be passed to popover
            vc.popoverItem = item
            vc.popoverItemVarietal = itemVarietal
            vc.modGroups = modifierGroups
            vc.modGroupDict = modDict
            vc.taxRates = itemTaxRates
            
            print("item Tax Rates are: \(itemTaxRates)")
            
            
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
       
        modifierGroups = []

        delegate?.opaqueWindow()
        
        
        print("Popover closed.")
        
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    
    // MODIFIER  QUERY
    func modifierQuery(modifierGroupObject: PFObject) -> [PFObject] {
        
        let modArray: [PFObject]?
        
        let modifierGroupId = modifierGroupObject["cloverId"] as? String
        
        let modifierQuery:PFQuery = PFQuery(className: "Modifier")
        modifierQuery.whereKey("modifierGroupId", containsString: modifierGroupId)
        modifierQuery.orderByAscending("price")

            // Synchronously Return Modifiers
            do {
                modArray = try modifierQuery.findObjects() as [PFObject]
            } catch _ {
                modArray = nil
            }
            
            print("Queried modifier group: \(modifierGroupObject["name"])")

            return modArray!
            
    }
    
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
