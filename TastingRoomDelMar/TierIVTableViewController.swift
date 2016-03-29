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
        self.tableView.reloadData()
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
        cell.altNameTextView.scrollEnabled = false
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
        if let productPrice = self.tierIVTableArray[indexPath.row]["prices"] {
            cell.pricingLabel?.text = self.tierIVTableArray[indexPath.row]["prices"] as! String
            cell.pricingLabel?.font = UIFont(name: "OpenSans", size: 12)
        
        // Prices NOT Found in Item Table
        } else {
            cell.pricingLabel?.text = ""
        }
        // ------------------------- END
        

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
        
        
//        var cellText: String = "Go get some text for your cell."
//        var cellFont: UIFont = UIFont(name: "Helvetica", size: 17.0)
//        var constraintSize: CGSize = CGSizeMake(280.0, MAXFLOAT)
//        var labelSize: CGSize = cellText.sizeWithFont(cellFont, constrainedToSize: constraintSize, lineBreakMode: .WordWrap)
        
//        var cellText = product["info"] as! String
//        var cellFont = UIFont.headerFont(14)
//        var constraintSize = CGSizeMake(225.0, CGFloat(MAXFLOAT))
//        
//        _ = cellText.sizeWithFont(cellFont, constrainedToSize: constraintSize, lineBreakMode: .ByCharWrapping)
//        
//        var textViewSize = cellText.boundingRectWithSize(bounds.size, options: NSStringDrawingOptions([.UsesLineFragmentOrigin, .UsesFontLeading]), attributes: [NSFontAttributeName : 14], context: nil)
        
        let cellHeight = 60 + largestHeight
        
        return cellHeight
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)! as! TierIVTableViewCell
        
        additions.removeAll()
        product = tierIVTableArray[indexPath.row]

        
        // IF HARVEST: Get Additions and Set
        // ------------ BEGIN
        if route[1]["name"] as! String == "Harvest" {
            
            print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
            
            let additionsRaw = tierIVTableArray[indexPath.row]["additions"]
            
            for var i = 0; i < additionsRaw.count; ++i {
                additions.append(additionsRaw[i])
            }
            
            print("Additions Created: \(additions)")
            
        }
        // ------------- END

        
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
                    
                    additions.removeAll()
                    
                    indexPath = tableView.indexPathForCell(cell)
                    product = tierIVTableArray[indexPath.row]
                    
                    // IF HARVEST: Get Additions and Set
                    // ------------ BEGIN
                    if route[1]["name"] as! String == "Harvest" {
                        
                        print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
                        
                        let additionsRaw = tierIVTableArray[indexPath.row]["additions"]

                        for var i = 0; i < additionsRaw.count; ++i {
                            additions.append(additionsRaw[i])
                        }
                        
                        print("Additions Created: \(additions)")
                        
                    }
                    // ------------- END
                    
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
            // ------------- BEGIN
            // IF HARVEST
            var popoverDynamicHeight: Int!
            
            if route[1]["name"] as! String == "Harvest" {
                popoverDynamicHeight = additions.count
            // NOT HARVEST
            } else {
                popoverDynamicHeight = 1
            }
            
            // ------------- END

            
            
            let popoverHeightCalculation = ((popoverDynamicHeight + 3) * 100)
            popoverHeight = CGFloat(popoverHeightCalculation)
            popoverWidth = tableView.bounds.size.width
            vc.preferredContentSize = CGSizeMake(popoverWidth, popoverHeight)

            
            AnimationManager.sharedInstance.opaqueWindow(self)
            

            // Data to be passed to popover
            vc.popoverItem = product
            vc.popoverItemVarietal = productVarietal
            
            // IF HARVEST
            // ------------ BEGIN
            if route[1]["name"] as! String == "Harvest" {
                
                
                
                
                vc.popoverAdditions = additions
                
                
                
                
            // NOT HARVEST
            } else {
                let subproductsArray = subproductQuery(product)
                vc.subproducts = subproductsArray
            }
            // ------------ END
            
            var controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
            
                controller?.delegate = self
                            
            }
            

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
    func subproductQuery(parent: PFObject) -> [PFObject] {
        
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
    
        print("Subproducts query has retrieved \(subproductsArray!.count) subproducts.")
        return subproductsArray!
        
    }
    

    
}
