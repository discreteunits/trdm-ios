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

    var popover: UIPopoverController?
    
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


// ---------------------
    
    override func viewWillAppear(animated: Bool) {
        
        AnimationManager.sharedInstance.animateTable(self.tableView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        
        cell.addToOrderButton.layer.cornerRadius = 6.0
        cell.addToOrderButton.clipsToBounds = true
        
        
        cell.itemNameLabel?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
        cell.itemNameLabel?.font = UIFont.headerFont(24)
        cell.altNameTextView?.text = self.tierIVTableArray[indexPath.row]["info"] as! String?
        cell.altNameTextView?.font = UIFont.basicFont(14)

        
        // Adjustment For Text View Text Wrapping
        // ------------------------- BEGIN
        cell.altNameTextView.scrollEnabled = true
        cell.altNameTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.altNameTextView.contentInset = UIEdgeInsets(top: -10,left: -5,bottom: -10,right: 0)
        cell.altNameTextView.textContainer.maximumNumberOfLines = 0
        cell.altNameTextView?.sizeToFit()
        
        let textViewHeight = cell.altNameTextView.contentSize.height

        
        heights.append(textViewHeight)
        largestHeight = heights.maxElement()!
        // ------------------------ END
        
        
        // Prices From Product Table
        // ------------------------- BEGIN
        // ----- IF HARVEST -----
        if route[1]["name"] as! String == "Harvest" {
            
            cell.pricingLabel?.text = "\(self.tierIVTableArray[indexPath.row]["price"])"
            cell.pricingLabel?.font = UIFont(name: "OpenSans", size: 12)
            
        } else {
        
            if let productPrice = self.tierIVTableArray[indexPath.row]["prices"] {
                cell.pricingLabel?.text = self.tierIVTableArray[indexPath.row]["prices"] as! String
                cell.pricingLabel?.font = UIFont(name: "OpenSans", size: 12)
        
            // Prices NOT Found in Item Table
            } else {
                cell.pricingLabel?.text = ""
            }
            // ------------------------- END
        }
        // ----- END
        

        // ASYNC: Get Varietal / Beer Style
        // --------------------- BEGIN
        dispatch_async(dispatch_get_main_queue()) {
            
            if let productCategories = self.tierIVTableArray[indexPath.row]["categories"] as? [PFObject] {

                for categoryObject in productCategories {
                    
                    if self.tierIVCollectionArray.contains(categoryObject) {

                        cell.varietalLabel?.text = categoryObject["name"] as? String
                        cell.varietalLabel?.font = UIFont(name: "OpenSans", size: 16)
                        
                        self.productVarietal = categoryObject as PFObject!

                    }
                    
                }
            
            }
            
        }
        // ----------------------- END
        
        // Guard Against Not Finding A Varietal
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
        
        additions.removeAll()
        product = tierIVTableArray[indexPath.row]

        // ----- HARVEST BEGIN ------
        if route[1]["name"] as! String == "Harvest" {
            
            
            if printFlag {
                print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
            }
            
            let additionsRaw = tierIVTableArray[indexPath.row]["additions"]
            
            for var i = 0; i < additionsRaw.count; ++i {
                additions.append(additionsRaw[i])
            }
            
            if printFlag {
                print("Additions Created: \(additions)")
            }
            
        }
        // ----- END -----

        
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        if printFlag {
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
                    
                    // ----- HARVEST BEGIN ------
                    if route[1]["name"] as! String == "Harvest" {
                        
                        if printFlag {
                            print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
                        }
                        
                        let additionsRaw = tierIVTableArray[indexPath.row]["additions"]

                        for var i = 0; i < additionsRaw.count; ++i {
                            additions.append(additionsRaw[i])
                        }
                        
                        if printFlag {
                            print("Additions Created: \(additions)")
                        }
                    }
                    // ----- END -----
                    
                }
                
            }
            
        }
   
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        if printFlag {
            print("------------------------")
        }
        
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
            
            let vc = segue.destinationViewController as! PopoverViewController
            
            // Dynamically assign Popover Window Size
            
            
            // ----- HARVEST BEGIN ------
            var popoverDynamicHeight: Int!
            
            if route[1]["name"] as! String == "Harvest" {
                popoverDynamicHeight = additions.count
            } else {
                popoverDynamicHeight = 1
            }
            // ----- END -----

            
            let popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
            popoverHeight = CGFloat(popoverHeightCalculation)
            popoverWidth = tableView.bounds.size.width
            vc.preferredContentSize = CGSizeMake(popoverWidth, popoverHeight)
            

            
            AnimationManager.sharedInstance.opaqueWindow(self.parentViewController!)

            getVarietal()
            
            // Data to be passed to popover
            vc.popoverItem = product
            vc.popoverItemVarietal = productVarietal
            
            
            // ----- HARVEST BEGIN ------
            if route[1]["name"] as! String == "Harvest" {
                
                vc.popoverAdditions = additions
                
            } else {
                let subproductsArray = subproductQuery(product)
                vc.subproducts = subproductsArray
            }
            // ----- END -----
            
            var controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                
                // CENTER POPOVER
                
                let bounds: CGRect = (delegate?.getViewBounds())!
                let position = (CGFloat(bounds.height) - popoverHeight) - 50
            
                controller!.sourceRect = CGRectMake(0, position, 0, 0)
                controller?.delegate = self
                            
            }

        }
        
    }
    
    
    // PRESENTATION CONTROLLER DATA SOURCE
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        AnimationManager.sharedInstance.opaqueWindow(self.parentViewController!)
        
        if printFlag {
            print("Popover closed.")
        }
        
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    // SUBPRODUCT QUERY
    func subproductQuery(parent: PFObject) -> [Product] {
        
        let subproductsArray: [PFObject]?
        let parentId = parent.objectId!
        
        let query:PFQuery = PFQuery(className: "Product")
        query.whereKey("productType", equalTo: parentId)
        
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
            
            var newSubproduct = Product()
            newSubproduct.id = subproduct.objectId!
            newSubproduct.lightspeedId = String(subproduct["lightspeedId"])
            newSubproduct.name = subproduct["name"] as! String
            newSubproduct.info = subproduct["info"] as! String
            
            let productPrice = subproduct["price"] as! Double
            newSubproduct.price = productPrice
            
            convertedSubproducts.append(newSubproduct)
            
        }
        
        // Sort Subproducts by Price
        convertedSubproducts.sortInPlace { $0.price < $1.price }


        return convertedSubproducts
        
    }
    
}
