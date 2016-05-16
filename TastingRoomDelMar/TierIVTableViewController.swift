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
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
    
    
    func makeAttributedString(name:String, info:String, prices:String) -> NSAttributedString {
        
        let nameAttributes = [NSFontAttributeName: UIFont.headerFont(24), NSForegroundColorAttributeName: UIColor.blackColor()]
        let infoAttributes = [NSFontAttributeName: UIFont.basicFont(16)]
        let paddingAttributes = [NSFontAttributeName: UIFont.basicFont(8)]
        let pricesAttributes = [NSFontAttributeName: UIFont.scriptFont(18)]
        
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" || RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            
            let nameString = NSMutableAttributedString(string: "\(name)\n", attributes: nameAttributes)
            let paddingString = NSAttributedString(string: "\n", attributes: paddingAttributes)
            let pricesString = NSAttributedString(string: prices, attributes: pricesAttributes)
            
            nameString.appendAttributedString(paddingString)
            nameString.appendAttributedString(pricesString)
            
            return nameString

            
        } else {
            
            let nameString = NSMutableAttributedString(string: "\(name)\n", attributes: nameAttributes)
            let infoString = NSAttributedString(string: "\(info)\n", attributes: infoAttributes)
            let paddingString = NSAttributedString(string: " \n", attributes: paddingAttributes)
            let pricesString = NSAttributedString(string: prices, attributes: pricesAttributes)
            
            nameString.appendAttributedString(infoString)
            nameString.appendAttributedString(paddingString)
            nameString.appendAttributedString(pricesString)
            
            return nameString
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! TierIVTableViewCell
        
//        // Disable Add To Tab buttons if user is not logged in
//        if TabManager.sharedInstance.currentTab.userId == "" {
//            cell.addToOrderButton.hidden = false
//            cell.addToOrderButton.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
//            cell.addToOrderButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
//            cell.addToOrderButton.layer.cornerRadius = 6.0
//            cell.addToOrderButton.clipsToBounds = true
//            cell.userInteractionEnabled = false
//        } else {
//            cell.addToOrderButton.layer.cornerRadius = 6.0
//            cell.addToOrderButton.clipsToBounds = true
//        }
        
        cell.addToOrderButton.layer.cornerRadius = 6.0
        cell.addToOrderButton.clipsToBounds = true
        
        
        
        let product = tierIVTableArray[indexPath.row]
        
        
        // MERCH AND EVENTS
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" || RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: String(product["priceWithoutVat"]))
        
        // BEER AND WINE
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Vines" || RouteManager.sharedInstance.TierTwo!["name"] as! String == "Hops" {
            
            if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {
                cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: "\(product["priceWithoutVat"])")
            } else {
                cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: product["prices"] as! String)
            }
        
        // FOOD
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            
            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: String(product["deliveryPriceWithoutVat"]))
            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: String(product["takeawayPriceWithoutVat"]))
            } else {
                cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: String(product["deliveryPriceWithoutVat"]))
            }
        
        // DEFAULT
        } else {
            cell.tierIVTableDataLabel?.attributedText = makeAttributedString(product["name"] as! String, info: product["info"] as! String, prices: String(product["priceWithoutVat"]))
        }
        
        
        return cell
          
    }

    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if TabManager.sharedInstance.currentTab.userId == "" {
            
            AlertManager.sharedInstance.whoopsLoggedInAlert(self, title: "Whoops!", message: "You must be logged in to add items to your tab.")
            
        } else {
            
        
        additions.removeAll()
        product = tierIVTableArray[indexPath.row]

        // ----- CONDITIONAL ROUTING BEGIN ------
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            
        } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            
            if tierIVTableArray[indexPath.row]["additions"] != nil {
                    print("This item contains: \(tierIVTableArray[indexPath.row]["additions"].count) raw additions.")
               
                let additionsRaw = tierIVTableArray[indexPath.row]["additions"]
                    
                for i in 0 ..< additionsRaw.count {
                    if additionsRaw[i]["name"]! as! String != "Table Number" {
                        if additionsRaw[i]["name"]! as! String != "Custom modifier" {
                            additions.append(additionsRaw[i])
                        }
                    }
                }
                    
                print("Additions Created: \(additions)")
            }
        }
        // ----- END -----

        
        performSegueWithIdentifier("showItemConfig", sender: self)
        
        print("------------------------")
        
        
    }
    }
    
    // SEGUE TRIGGER AND PREPARATION
    @IBAction func addToOrder(sender: AnyObject) {
        
        addToOrderButton(sender)
        
    }
    
    func addToOrderButton(sender: AnyObject) {
        
        if TabManager.sharedInstance.currentTab.userId == "" {
        
            AlertManager.sharedInstance.whoopsLoggedInAlert(self, title: "Whoops!", message: "You must be logged in to add items to your tab.")
            
        } else {
        
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
                                    if additionsRaw[i]["name"]! as! String != "Custom modifier" {
                                        additions.append(additionsRaw[i])
                                    }
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
    
    func getLines(text:String) -> Int {
        
        var characterCountPerLine = Int()
        let screenWidth = UIScreen.mainScreen().bounds.width
        if screenWidth < 375 {
            characterCountPerLine = 33
        } else {
            characterCountPerLine = 39
        }
        
        
        let textCount = text.characters.count
        let textLineDecimal = textCount / characterCountPerLine
        let textAproxIncreased = textLineDecimal + 1
        let textLines = textAproxIncreased - (textAproxIncreased % 1)
        
        print("Selected Popover's Name Label Will Be: \(textLines) lines.")
        
        return textLines
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showItemConfig" {
            
            var controller = popoverPresentationController
            
            let vc = segue.destinationViewController as! PopoverViewController
            
            
            // Dynamically assign Popover Window Size
            var popoverDynamicHeight: Int!
            var popoverHeightCalculation: Int!
            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                
                let numberOfLines = getLines(product["name"] as! String)
                let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 1) * 100) + nameHeight

            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                
                let numberOfLines = getLines(product["name"] as! String)
                let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 1) * 100) + nameHeight

            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                
                let numberOfLines = getLines(product["name"] as! String)
                let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                
                popoverDynamicHeight = additions.count
                popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100) + nameHeight
                vc.popoverAdditions = additions

            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                
                
                // Parent Product Route
                if product["productType"] as! String == "CHOICE" {
                    
                    let numberOfLines = getLines(product["name"] as! String)
                    let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                    
                    popoverDynamicHeight = 1
                    popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100) + nameHeight
                    let subproductsArray = subproductQuery(product)
                    vc.subproducts = subproductsArray
                // Subproduct Route
                } else if product["productType"] as! String != "" {
                    
                    let numberOfLines = getLines(product["name"] as! String)
                    let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                    
                    popoverDynamicHeight = 1
                    popoverHeightCalculation = ((popoverDynamicHeight + 1) * 100) + nameHeight
                // Product Route
                } else {
                    
                    let numberOfLines = getLines(product["name"] as! String)
                    let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                    
                    popoverDynamicHeight = 1
                    popoverHeightCalculation = ((popoverDynamicHeight + 1) * 100) + nameHeight
                }
                
            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Surrender" {
                
                
                
                let numberOfLines = getLines(product["name"] as! String)
                let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 1) * 100) + nameHeight
                

            } else if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {
                
                let numberOfLines = getLines(product["name"] as! String)
                let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 1) * 100) + nameHeight
            
                
                
            } else {
                
                let numberOfLines = getLines(product["name"] as! String)
                let nameHeight = (numberOfLines * 24) + 2 // 2 is padding
                
                popoverDynamicHeight = 1
                popoverHeightCalculation = ((popoverDynamicHeight + 2) * 100) + nameHeight
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
