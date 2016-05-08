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

    var cellHeight = CGFloat()
    
    
    var dynamicCellHeight = CGFloat()
    
    
// ---------------------
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // need this?
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
//        self.tableView.setNeedsLayout()
//        self.tableView.layoutIfNeeded()
        // ---
        
//        AnimationManager.sharedInstance.animateTable(self.tableView)

        tableView.reloadData()
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.tagsArrayCreation()
            
            print("tagsArrayCreation Completed")
            
        }
        
        tableView.tableFooterView = UIView()
                
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
        
        cell.titleTextView?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
        cell.altNameTextView?.text = self.tierIVTableArray[indexPath.row]["info"] as! String? ?? "[No Info]"
        
        cell.titleTextView?.font = UIFont.headerFont(24)
        cell.altNameTextView?.font = UIFont.basicFont(14)
        cell.pricingLabel?.font = UIFont.basicFont(12)


        // Adjustment For Text View Text Wrapping
        // ------------------------- BEGIN
        cell.titleTextView.backgroundColor = UIColor.clearColor()
        cell.titleTextView.scrollEnabled = false
        cell.titleTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.titleTextView.contentInset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        cell.titleTextView.textContainer.maximumNumberOfLines = 0
        cell.titleTextView.sizeToFit()
        
        let titleTextViewHeight = cell.titleTextView.contentSize.height
        print("titleTextViewHeight: \(titleTextViewHeight)")
        
        cell.altNameTextView.backgroundColor = UIColor.clearColor()
        cell.altNameTextView.scrollEnabled = false
        cell.altNameTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.altNameTextView.contentInset = UIEdgeInsets(top: 0,left: -6, bottom: 0,right: 0)
        cell.altNameTextView.textContainer.maximumNumberOfLines = 0
        cell.altNameTextView.sizeToFit()
        
        let altNameTextViewHeight = cell.altNameTextView.contentSize.height
        print("altNameTextViewHeight: \(altNameTextViewHeight)")
        
        
        dynamicCellHeight = altNameTextViewHeight + titleTextViewHeight
        dynamicCellHeight = dynamicCellHeight + 60
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

    

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    


    
    func calculateHeight(titleText:String, infoText:String) -> CGFloat {
        
        print("88888888888888888888888888888888888")

        
        // get number of lines in decimal form
        // multiply by font size
        // increase by 1 in prep for removing decimals
        // remove any decimals
        
        print("titleText: \(titleText)")
        print("title character count: \(titleText.characters.count)")

        let titleTextCount = Double(titleText.characters.count)
        let titleHeightAprox = titleTextCount / 39.0
        print("titleHeightAprox: \(titleHeightAprox)")
        let titleHeight = titleHeightAprox * 24
        print("titleHeight: \(titleHeight)")
        let titleIncreased = titleHeight + 1
        print("titleIncreased: \(titleIncreased)")
        let titleTotalHeight = Int(titleIncreased - (titleIncreased % 1))
        
        print("Title Wrapped Height: \(titleTotalHeight)")
        
        
        let infoTextCount = Double(infoText.characters.count)
        let infoHeightAprox = infoTextCount / 45
        let infoHeight = infoHeightAprox * 14
        let infoIncreased = infoHeight + 1
        let infoTotalHeight = Int(infoIncreased - (infoIncreased % 1))
        
        print("Info Wrapped Height: \(infoTotalHeight)")
        
        
        let cellHeightTotal = (titleTotalHeight + infoTotalHeight) + 60
        
        print("cellHeightTotal: \(cellHeightTotal)")
        
        
        print("88888888888888888888888888888888888")

        
        return CGFloat(cellHeightTotal)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Taylor Option
//        let titleText:String = tierIVTableArray[indexPath.row]["name"] as! String
//        let infoText:String = tierIVTableArray[indexPath.row]["info"] as! String
//        
//        let size = self.calculateHeight(titleText, infoText: infoText)
        // ----
        
        
        print("Cell \(indexPath.row) height is: \(dynamicCellHeight)")

        
        
        
        
        return UITableViewAutomaticDimension
        
//        return dynamicCellHeight
        
//        return size
        
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
                
                popoverDynamicHeight = additions.count - 1
                popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
                vc.popoverAdditions = additions

            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                
                
                // Parent Product Route
                if product["productType"] as! String == "CHOICE" {
                    popoverDynamicHeight = 1
                    popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
                    let subproductsArray = subproductQuery(product)
                    vc.subproducts = subproductsArray
                // Subproduct Route
                } else if product["productType"] as! String != "" {
                    popoverDynamicHeight = 1
                    popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100)
                // Product Route
                } else {
                    popoverDynamicHeight = 1
                    popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100)
                }
                


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
