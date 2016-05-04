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
    func getViewBounds() -> CGRect
}

class TierIVTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var TierIVViewControllerRef: TierIVViewController?
    var TierIVCollectionViewControllerRef: TierIVCollectionViewController?
    
    @IBOutlet weak var addToTabButton: UIButton!
    
    var delegate: TierIVTableViewDelegate?
    
    var tierIVCollectionArray = [PFObject]()
    var tierIVTableArray = [PFObject]()

    var popover: UIPopoverPresentationController?
    
    var product: PFObject!
    var productVarietal: PFObject!
    
    var indexPath: NSIndexPath!
    
    var popoverHeight: CGFloat!
    var popoverWidth: CGFloat!
    
    var productTaxRates = [PFObject]()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var heights = [CGFloat]()
    var largestHeight = CGFloat()
    
    // IF HARVEST
    var additions = [AnyObject]()

    var tagsArray = [PFObject]()


// ---------------------
    
    override func viewWillAppear(animated: Bool) {
        
        AnimationManager.sharedInstance.animateTable(self.tableView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.tagsArrayCreation()
            
            print("tagsArrayCreation Completed")
            
        }
        
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        
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

        // If User Is Logged in
        if TabManager.sharedInstance.currentTab.userId == "" {
            cell.addToOrderButton.hidden = false
            cell.addToOrderButton.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
            cell.addToOrderButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            cell.addToOrderButton.layer.cornerRadius = 6.0
            cell.addToOrderButton.clipsToBounds = true
            cell.userInteractionEnabled = false
        } else {
            cell.addToOrderButton.layer.cornerRadius = 6.0
            cell.addToOrderButton.clipsToBounds = true
        }
        
        
        cell.itemNameLabel?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
        cell.itemNameLabel?.font = UIFont.headerFont(24)
        cell.altNameTextView?.text = self.tierIVTableArray[indexPath.row]["info"] as! String?
        cell.altNameTextView?.font = UIFont.basicFont(14)
        cell.pricingLabel?.font = UIFont.basicFont(12)


        // Adjustment For Text View Text Wrapping
        // ------------------------- BEGIN
        cell.altNameTextView.backgroundColor = UIColor.clearColor()
        cell.altNameTextView.frame.size.width = (UIScreen.mainScreen().bounds.width - 80)
        cell.altNameTextView.scrollEnabled = false
        cell.altNameTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.altNameTextView.contentInset = UIEdgeInsets(top: -10,left: -5,bottom: -10,right: 0)
        cell.altNameTextView.textContainer.maximumNumberOfLines = 0
        cell.altNameTextView?.sizeToFit()
        
        let textViewHeight = cell.altNameTextView.contentSize.height

        
//        cell.altNameTextView.contentSize.height = textViewHeight

//        cell.altNameTextView.frame = CGRect(x: 0, y: 0, width: 200, height: textViewHeight)
        
//        cell.altNameTextView.frame.size.height = textViewHeight
        
        
//        cell.tableStackView.frame = CGRectMake(CGRectGetMidX(cell.contentView.bounds), CGRectGetMidY(cell.contentView.bounds), 0, textViewHeight)
//        cell.tableStackView.sizeToFit()

//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
        
        
        // Get Largest Cell Size After Wrapping
        heights.append(textViewHeight)
        largestHeight = heights.maxElement()!
        
        // ------------------------ END

        
        
        // Prices From Product Table
        // ------------------------- BEGIN
        // ----- IF HARVEST -----
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            
            cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["priceWithoutVat"])"
            
        } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            
            cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["priceWithoutVat"])"
            
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            
            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["deliveryPriceWithoutVat"])"
            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["takeawayPriceWithoutVat"])"
            } else {
                cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["deliveryPriceWithoutVat"])"
            }
            
//            cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["price"])"
            
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
            
            cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["priceWithoutVat"])"
            
        } else {
            
            if let productPrice = self.tierIVTableArray[indexPath.row]["prices"] {
                cell.pricingLabel?.text = self.tierIVTableArray[indexPath.row]["prices"] as? String
                cell.pricingLabel?.font = UIFont.basicFont(12)
                
            // Prices NOT Found in Item Table
            } else {
                cell.pricingLabel?.text = ""
            }

        } // ----- END
        
        return cell
        
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cellHeight = 90 + largestHeight

        return cellHeight
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        // If User Is NOT Logged in
        if TabManager.sharedInstance.currentTab.userId == "" {
            
            // Do Nothing
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! TierIVTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
            
            AlertManager.sharedInstance.anonymousMenuAlert(self, title: "Whoops!", message: "You need to have an account to add items to your tab.")

            
        } else {
        
            additions.removeAll()
            product = tierIVTableArray[indexPath.row]

            // ----- HARVEST BEGIN ------
            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            
            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            
            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            
                if tierIVTableArray[indexPath.row]["additions"] != nil {
                    print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
               
                    let additionsRaw = tierIVTableArray[indexPath.row]["additions"]
                    
                    for i in 0 ..< additionsRaw.count {
                        if additionsRaw[i]["name"]! as! String != "Table Number" {
                            additions.append(additionsRaw[i])
                        }
                    }
                    
                    print("Additions Created: \(additions)")
                }
            }
            // ----- END -----

        
            
            // Start Activity Indicator
            ActivityManager.sharedInstance.activityStart(self)
            
            performSegueWithIdentifier("showItemConfig", sender: self)
        
            print("------------------------")
        
        }
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
                    
                    additions.removeAll()
                    
                    indexPath = tableView.indexPathForCell(cell)
                    product = tierIVTableArray[indexPath.row]
                    
                    // ----- HARVEST OR EVENTS BEGIN ------
                    if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                        
                    } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                        
                    } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                        
                        if (tierIVTableArray[indexPath.row]["additions"] != nil) {
                            
                            print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
                            
                            let additionsRaw = tierIVTableArray[indexPath.row]["additions"]
                            
                            for i in 0 ..< additionsRaw.count {
                                if additionsRaw[i]["name"]! as! String != "Table Number" {
                                    additions.append(additionsRaw[i])
                                }
                            }
                            
                            print("Additions Created: \(additions)")
                            
                        }
                    } // ----- END
                }
            }
        }
   
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        print("------------------------")
        
    }
    
    func getVarietal() {
        
        if let productCategories = self.product["categories"] as? [PFObject] {
            
            for categoryObject in productCategories {
                
                if self.tierIVCollectionArray.contains(categoryObject) {
                    
                    self.productVarietal = categoryObject as PFObject!
                    
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showItemConfig" {
            
            
            // Stop Activity Indicator
            ActivityManager.sharedInstance.activityStop(self)
            
            var controller = popoverPresentationController
            
            let vc = segue.destinationViewController as! PopoverViewController
            
            
            // Dynamically assign Popover Window Size
            var popoverDynamicHeight: Int!
            var popoverHeightCalculation: Int!
            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100)

            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100)

            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                
                popoverDynamicHeight = additions.count
                popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
                vc.popoverAdditions = additions

            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100)

            } else if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100)
            
            } else {
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
                let subproductsArray = subproductQuery(product)
                vc.subproducts = subproductsArray

            }
            // ----- END -----

            
            popoverHeight = CGFloat(popoverHeightCalculation)
            popoverWidth = tableView.bounds.size.width
            vc.preferredContentSize = CGSizeMake(popoverWidth, 1)
            
            // Add Opaque Background
            AnimationManager.sharedInstance.opaqueWindow(self.parentViewController!)

            
            getVarietal()
            
            
            // Data to be passed to popover
            vc.popoverItem = product
            vc.popoverItemVarietal = productVarietal
            vc.height = popoverHeight
            vc.width = popoverWidth

            
            controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

            if controller != nil {
                
                controller!.sourceView = self.view
                controller!.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds) - 8, CGRectGetMidY(self.view.bounds) - 50, 0, 0)
                controller?.delegate = self
                
            }
        }
    }
    
    // PRESENTATION CONTROLLER DATA SOURCE
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        // Remove Opaque Window
        AnimationManager.sharedInstance.opaqueWindow(self.parentViewController!)
        
        print("Popover closed.")
        
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    // TAGS ARRAY CREATION
    func tagsArrayCreation() {
        
        // Clean Up
        self.tagsArray.removeAll()
        
        // Set
        for object in RouteManager.sharedInstance.Route! as! [PFObject] {
            
            let tag = object["category"] as! PFObject
            
            self.tagsArray.append(tag)
            
        }
    }
    
    // SUBPRODUCT QUERY
    func subproductQuery(parent: PFObject) -> [Product] {
        
        let subproductsArray: [PFObject]?
        let parentId = parent.objectId!
        
        let query:PFQuery = PFQuery(className: "Product")
        query.whereKey("productType", equalTo: parentId)
        query.whereKey("categories", containsAllObjectsInArray: tagsArray)
        
        // Synchronously Return Subproducts
        do {
            subproductsArray = try query.findObjects() as [PFObject]
        } catch _ {
            subproductsArray = nil
        }
        
        if printFlag {
            print("Subproducts query has retrieved \(subproductsArray!.count) subproducts.")
        }
        
        var convertedSubproducts = [Product]()
        
        for subproduct in subproductsArray! {
            
            // Subproduct Of LineItem
            var newSubproduct = Product()
            newSubproduct.objectId = subproduct.objectId!
            newSubproduct.productId = String(subproduct["lightspeedId"])
            newSubproduct.name = subproduct["name"] as! String
            
            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                newSubproduct.price = subproduct["deliveryPriceWithoutVat"] as! Double
            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                newSubproduct.price = subproduct["takeawayPriceWithoutVat"] as! Double
            } else {
                newSubproduct.price = subproduct["deliveryPriceWithoutVat"] as! Double
            }
            
            
            if subproduct["info"] != nil {
                newSubproduct.info = subproduct["info"] as! String
            }
            
            convertedSubproducts.append(newSubproduct)
            
        }
        
        // Sort Subproducts by Price
        convertedSubproducts.sortInPlace { $0.price < $1.price }

        return convertedSubproducts
        
    }
}
