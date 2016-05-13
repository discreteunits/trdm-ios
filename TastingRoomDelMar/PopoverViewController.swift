//
//  PopoverViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/18/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class PopoverViewController: UITableViewController {
    
    // Received Data From Table Controller
    var popoverItem: PFObject!
    var popoverItemVarietal: PFObject!
    var taxRates = [PFObject]()
    var popoverAdditions = [AnyObject]()
    var subproducts = [Product]()
    
    // Row QTY Data
    var rows: Int!
    var quantityRow: Int!
    var actionRow: Int!
    
    // Maximum Order Quantity
    var maxQuantity = 10
    
    // User Choices
    var productChoice = Product() // Beer and Wine
    var productAdditionChoices = [Addition]() // Harvest
    
    var quantityChoice = String()
    
    // Collect All Additions For This Item
    var additions:[Addition] = [Addition]()
    
    var height = CGFloat()
    var width = CGFloat()

    // Price Formatter
    let formatter = PriceFormatManager.priceFormatManager
    
// --------------------
    override func viewWillAppear(animated: Bool) {
        
        createAdditions()
        
        //        self.tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delay(0.1) { () -> () in
            self.preferredContentSize = CGSize(width: self.width, height: self.height)
            self.tableView.reloadData()
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createAdditions() {
        
        // Create Additions with Values
        for i in 0 ..< popoverAdditions.count {
            
            let additionValues = popoverAdditions[i]["values"]!
            
            var convertedAdditionValues: [Value] = [Value]()
            
            for value in additionValues as! [[String:AnyObject]] {
                
                var newValue = Value()
                newValue.modifierId = String(value["id"]!)
                newValue.info = value["info"] as! String
                newValue.name = value["name"] as! String
                newValue.price = String(value["price"]!)
                newValue.priceWithoutVAT = String(value["priceWithoutVAT"]!)
                
                convertedAdditionValues.append(newValue)
                
            }
            
            let additionRaw = popoverAdditions[i]
            
            // Only Create Additions that are not "CUSTOM MODIFIER"
//            if additionRaw["displayName"]! as! String != "Custom modifier" {

                var newAddition = Addition()
                newAddition.displayName = additionRaw["displayName"]! as! String
                newAddition.modifierValueId = String(additionRaw["id"]!)
                newAddition.maxSelectedAmount = String(additionRaw["maxSelectedAmount"]!)
                newAddition.minSelectedAmount = String(additionRaw["minSelectedAmount"]!)
                newAddition.name = additionRaw["name"]! as! String
                newAddition.values = convertedAdditionValues
            
                self.additions.append(newAddition)
//            }
        }
    }
    
    // TABLE DELEGATE AND DATA SOURCE
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            rows = 3
        } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            rows = 3
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            rows = additions.count + 3
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
            
            if subproducts.count > 0 {
                rows = 4
            } else {
                rows = 3
            }
            
        } else if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {
            rows = 3
        } else {
            rows = 4
        }
            
        quantityRow = rows - 2
        actionRow = rows - 1
                        
        return rows
            
    }

    
    func makeAttributedString(name:String) -> NSAttributedString {
        
        let nameAttributes = [NSFontAttributeName: UIFont.headerFont(24), NSForegroundColorAttributeName: UIColor.blackColor()]
        
        let nameString = NSMutableAttributedString(string: "\(name)", attributes: nameAttributes)
        
        
        return nameString
        
        
    }
    
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = UITableViewCell()
            
            // Details Table Row
            if indexPath.row == 0 {
                
                var detailsCell: PopoverDetailsTableViewCell
                detailsCell = tableView.dequeueReusableCellWithIdentifier("PopoverDetailsTableCell",
                    forIndexPath: indexPath) as! PopoverDetailsTableViewCell
                
                detailsCell.contentView.tag = indexPath.row
                detailsCell.selectionStyle = UITableViewCellSelectionStyle.None

                
                detailsCell.titleDataLabel?.attributedText = makeAttributedString(popoverItem["name"] as! String)

  
                
                return detailsCell
                
            // Additions And Subproducts Table Row
            } else if (indexPath.row > 0) && (indexPath.row < quantityRow) {
                
                var sgCell: PopoverSGTableViewCell
                sgCell = tableView.dequeueReusableCellWithIdentifier("PopoverSGTableCell",
                    forIndexPath: indexPath) as! PopoverSGTableViewCell
                sgCell.contentView.tag = indexPath.row
                
                let trueIndex = indexPath.row - 1
                
                sgCell.servingLabel.layer.zPosition = 100
                sgCell.servingLabel.font = UIFont.headerFont(20)

                
                // IF HARVEST
                if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                    
                    sgCell.servingLabel.text = additions[trueIndex].name
                    
                // IF NOT HARVEST
                } else {
                    
                    sgCell.servingLabel.text = "servings"

                }
                
                return sgCell
                
            // Quantity Table Row
            } else if indexPath.row == quantityRow {
                
                var qtyCell: PopoverQuantityTableViewCell
                qtyCell = tableView.dequeueReusableCellWithIdentifier("PopoverQuantityTableCell",
                    forIndexPath: indexPath) as! PopoverQuantityTableViewCell
                qtyCell.contentView.tag = indexPath.row
                qtyCell.label.text = "quantity"
                qtyCell.label.font = UIFont.headerFont(20)
                
                return qtyCell
                
            // Action Table Row
            } else if indexPath.row == actionRow {
                
                var actionCell: PopoverActionTableViewCell
                actionCell = tableView.dequeueReusableCellWithIdentifier("PopoverActionTableCell",
                    forIndexPath: indexPath) as! PopoverActionTableViewCell
                actionCell.contentView.tag = indexPath.row
    
                return actionCell
                
            }
            
            return cell
            
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
        
            // Details Table Row
            if indexPath.row == 0 {
                
                guard let tableViewCell = cell as? PopoverDetailsTableViewCell else { return }
                
            // SubGroup Table Row
            } else if (indexPath.row > 0) && (indexPath.row < quantityRow ) {
                
                guard let tableViewCell = cell as? PopoverSGTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

            // Quantity Table Row
            } else if indexPath.row == quantityRow {
                
                guard let tableViewCell = cell as? PopoverQuantityTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

            // Action Table Row
            } else if indexPath.row == actionRow {
                
                guard let tableViewCell = cell as? PopoverActionTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

            }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cellHeight: CGFloat = CGFloat(100)
        
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row == actionRow {
            return 60
        }
        
        return cellHeight
        
        
    }
}


// COLLECTION DELEGATE AND DATA SOURCE
extension PopoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            let parent = collectionView.superview!.tag
            var numberOfItems: Int!
            
            // Details Table Row
            if parent == 0 {
                
                numberOfItems = 1
                
            // SubGroup Table Row
            } else if (parent > 0) && (parent < quantityRow ) {
                
                let trueIndex = parent - 1
                let subgroupCollectionCellCount: Int!
                
                // ----- HARVEST BEGIN ------
                if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                    
                    subgroupCollectionCellCount = additions[trueIndex].values.count
                    
                } else {
                    subgroupCollectionCellCount = subproducts.count
                }
                // ----- END -----
                
                numberOfItems = subgroupCollectionCellCount
                
            // Quantity Table Row
            } else if parent == quantityRow {
                
                numberOfItems = maxQuantity
                
            // Action Table Row
            } else if parent == actionRow {
                
                numberOfItems = 2

            }
            
            return numberOfItems
            
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = UICollectionViewCell()
            let parent = collectionView.superview!.tag
            
            // Details Table Row
            if parent == 0 {

                
            // SubGroup Table Row
            } else if (parent > 0) && (parent < quantityRow ) {
                
                var sgCollectionCell: PopoverSGCollectionViewCell
                sgCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverSGCollectionCell",
                    forIndexPath: indexPath) as! PopoverSGCollectionViewCell
                
                sgCollectionCell.backgroundColor = UIColor.whiteColor()
                sgCollectionCell.layer.borderWidth = 2
                sgCollectionCell.layer.borderColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
                sgCollectionCell.layer.cornerRadius = 10.0
                sgCollectionCell.clipsToBounds = true
                sgCollectionCell.label.font = UIFont.scriptFont(16)
                
                let trueIndex = parent - 1

                // ----- HARVEST BEGIN ------
                if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                    
                    sgCollectionCell.label.text = additions[trueIndex].values[indexPath.row].name
                
                } else {
                    
                    let subproduct = subproducts[indexPath.row]
                    

                    
                    let subproductPrice = subproduct.price
                    let convertedOrderAndServing = formatter.formatPrice(subproductPrice)
                    let orderAndServing = subproduct.info + "   " + convertedOrderAndServing
                    sgCollectionCell.label.text = orderAndServing
                    
                    
                }
                // ----- END -----
                
                return sgCollectionCell
                
            // Quantity Table Row
            } else if parent == quantityRow {
                
                var quantityCollectionCell: PopoverQuantityCollectionViewCell
                quantityCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverQuantityCollectionCell",
                    forIndexPath: indexPath) as! PopoverQuantityCollectionViewCell
                
                quantityCollectionCell.backgroundColor = UIColor.whiteColor()
                
                let trueIndex = String(indexPath.row + 1)
                quantityCollectionCell.label.text = trueIndex
                quantityCollectionCell.label.font = UIFont.scriptFont(16)
                
                quantityCollectionCell.layer.borderWidth = 2
                quantityCollectionCell.layer.borderColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
                quantityCollectionCell.layer.cornerRadius = 10.0
                quantityCollectionCell.clipsToBounds = true

                return quantityCollectionCell
                
            // Action Table Row
            } else if parent == actionRow {
                
                var actionCollectionCell: PopoverActionCollectionViewCell
                actionCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverActionCollectionCell",
                    forIndexPath: indexPath) as! PopoverActionCollectionViewCell
                
                actionCollectionCell.label.font = UIFont.scriptFont(20)
                actionCollectionCell.layer.cornerRadius = 6.0
                actionCollectionCell.clipsToBounds = true
                
                // Cancel
                if indexPath.row == 0 {
                    
                    actionCollectionCell.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
                    actionCollectionCell.label.textColor = UIColor.blackColor()
                    actionCollectionCell.label.text = "Cancel"
                    
                // Add to Tab
                } else if indexPath.row == 1 {
                    
                    actionCollectionCell.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
                    actionCollectionCell.label.textColor = UIColor.whiteColor()
                    actionCollectionCell.label.text = "Add to Tab"

                }
                
                return actionCollectionCell
                
            }
            
            return cell
            
    }
 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let parent = collectionView.superview!.tag
        let selectedCell = UICollectionViewCell()

        // Details Table Row
        if parent == 0 {
            
        // SubGroup Table Row
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverSGCollectionViewCell
            selectedCell.layer.cornerRadius = 10.0
            selectedCell.clipsToBounds = true
            selectedCell.label.textColor = UIColor.whiteColor()
            selectedCell.backgroundColor = UIColor.blackColor()
            
            // ----- HARVEST BEGIN ------
            if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                
                let trueIndex = parent - 1

                var selectedAddition = Addition()
                
                selectedAddition = additions[trueIndex]
                selectedAddition.values.removeAll()
                selectedAddition.values.append(additions[trueIndex].values[indexPath.row])
                
                print("Selected Addition with Value: \(selectedAddition)")
                
                productAdditionChoices.append(selectedAddition)
                
            } else {
                
                let subproduct = subproducts[indexPath.row]
                productChoice = subproduct
                
                print("User chose to add: \(productChoice.name)")
                
            }
            // ----- END -----

        // Quantity Table Row
        } else if parent == quantityRow {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverQuantityCollectionViewCell
            selectedCell.layer.cornerRadius = 10.0
            selectedCell.clipsToBounds = true
            selectedCell.label.textColor = UIColor.whiteColor()
            selectedCell.backgroundColor = UIColor.blackColor()
            
            quantityChoice = selectedCell.label.text!
            
            if printFlag {
                print("User chose a quantity of: \(quantityChoice)")
            }
            
        // Action Table Row
        } else if parent == actionRow {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverActionCollectionViewCell
            
            // Cancel Option
            if indexPath.row == 0 {
                
                // Revert view controllers, views, and collections back to pre-popover state
                self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
                
                let tierIVView = self.presentingViewController!.view
                if let viewWithTag = tierIVView!.viewWithTag(21) {
                    
                    viewWithTag.removeFromSuperview()
                    
                }
                
            // Add To Tab Option
            } else if indexPath.row == 1 {
                
                let completedChoices: Int!
                
                // ----- HARVEST BEGIN ------
                if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                    
                    completedChoices = 0

                } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                    
                    completedChoices = 0
                    
                } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                    
                   completedChoices = popoverAdditions.count
                
                } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                    
                    completedChoices = 0
                    
                } else if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {
                    
                    completedChoices = 0
                
                } else {
                    
                    completedChoices = 1
                    
                }
                // ----- END -----
                
                if popoverItem != nil {
                    if productChoice.name != "" || productAdditionChoices.count == completedChoices {
                        if quantityChoice != "" {
                            
                            // Begin Monetary Calculations
                            let taxString = popoverItem["taxClass"] as! String
                            let taxRateString = taxString.stringByReplacingOccurrencesOfString("BUILTIN-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            let taxRateConversion = Double(taxRateString)! / 100
                            let taxRateDouble = taxRateConversion
                            let lineitemQuantity = Double(quantityChoice)

                            print("Tax Rate: \(taxRateDouble)")
                            
                            
                            // Total All Subproduct Choice Prices
                            var totalChoicesPrice = Double()
                            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                                totalChoicesPrice = popoverItem["price"] as! Double
                            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                                totalChoicesPrice = popoverItem["price"] as! Double
                            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                                
                                if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                                    totalChoicesPrice = popoverItem["deliveryPriceWithoutVat"] as! Double
                                } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                                    totalChoicesPrice = popoverItem["takeawayPriceWithoutVat"] as! Double
                                } else {
                                    totalChoicesPrice = popoverItem["deliveryPriceWithoutVat"] as! Double
                                }
                                
                            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                                
                                if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                                    totalChoicesPrice = popoverItem["priceWithoutVat"] as! Double
                                } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                                    totalChoicesPrice = popoverItem["priceWithoutVat"] as! Double
                                } else {
                                    totalChoicesPrice = popoverItem["priceWithoutVat"] as! Double
                                }
                                
                            } else if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {

                                if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                                    totalChoicesPrice = popoverItem["deliveryPriceWithoutVat"] as! Double
                                } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                                    totalChoicesPrice = popoverItem["takeawayPriceWithoutVat"] as! Double
                                } else {
                                    totalChoicesPrice = popoverItem["deliveryPriceWithoutVat"] as! Double
                                }
                                
                            } else {
                                
                                totalChoicesPrice = productChoice.price
                                
                            }
                            
                            // Tax and Total for LineItem
                            let lineitemPreTax = lineitemQuantity! * (totalChoicesPrice)
                            let lineitemTax = lineitemPreTax * taxRateDouble
                            let lineitemTotal = lineitemTax + lineitemPreTax
                            
                            print("+++++++++++++++++++++++++++++++++++")
                            print("Tax String: \(popoverItem["taxClass"])")
                            print("Line Item Pre Tax: \(lineitemPreTax)")
                            print("Line Item Tax Calculated to: \(lineitemTax)")
                            print("Line Item Total: \(lineitemTotal)")
                            print("+++++++++++++++++++++++++++++++++++")
                            
                            
                            // LineItem Parent Product
                            var newProduct = Product()
                            newProduct.objectId = productChoice.objectId                 // Parse Obj ID of Subproduct
                            newProduct.productId = String(popoverItem["lightspeedId"])      // Lightspeed ID
                            newProduct.name = popoverItem["name"] as! String
                            newProduct.price = popoverItem["price"] as! Double
                            
                            if let info = popoverItem["info"] as? String {
                                newProduct.info = info
                            } else {
                                newProduct.info = ""
                            }
                            
                            
                            
                            // Begin Create LineItem
                            var newLineItem = LineItem()
                            
                            newLineItem.objectId = popoverItem.objectId!
                            newLineItem.productId = "\(popoverItem["lightspeedId"])"
                            newLineItem.quantity = Int(quantityChoice)!
                            
                            // Set Line Item Type (ie: Delivery, Take Away)
                            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Dine In" {
                                
                                newLineItem.type = "delivery"
                                
                            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Take Away" {
                                
                                newLineItem.type = "takeaway"
                                
                            } else {
                                newLineItem.type = ""  // Set Default
                            }
                            

                            newLineItem.name = popoverItem["name"] as! String
                            newLineItem.price = lineitemPreTax
                            newLineItem.tax = lineitemTax
                            
                            // ----- HARVEST BEGIN ------
                            if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                                newLineItem.varietal = ""
                                newLineItem.path = "Merch"
                            } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                                newLineItem.varietal = ""
                                newLineItem.path = "Event"
                            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                                newLineItem.varietal = ""
                                newLineItem.path = "Eat"
                            } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                                newLineItem.varietal = ""
                                newLineItem.path = "More"
                            } else if RouteManager.sharedInstance.TierThree!["name"] as! String == "Flights" {
                                newLineItem.varietal = ""
                                newLineItem.path = "Flights"
                            } else {
                                
                                newLineItem.varietal = ""

//                                newLineItem.varietal = popoverItemVarietal["name"] as! String
                                newLineItem.path = "Drink"
                            }
                            // ----- END -----
                            

                            newLineItem.product = newProduct
                            newLineItem.subproduct = productChoice
                            newLineItem.additions = productAdditionChoices

                            print("New LineItem created: \(newLineItem.name)")

                            
                            // Add LineItem to Tab
                            TabManager.sharedInstance.currentTab.lines.append(newLineItem)
                            
                            print("Line Item \(newLineItem.name) has been added to currentTab.")
                            
                            
                            // Clean Up
                            popoverAdditions.removeAll()
                            subproducts.removeAll()
                            productAdditionChoices.removeAll()
                            productChoice = Product()
                            taxRates.removeAll()
                            
            
                            // Confirm
                            AlertManager.sharedInstance.addedSuccess(self, title: "Added Successfully!", message: "Item has been added to your order!")

                            print("*****************************************")
                            print("Product added to tab: \(newLineItem)")
                            print("*****************************************")
                            
                            
                        } else {
                            AlertManager.sharedInstance.whoopsSelectModifiers(self, title: "Whoops!", message: "Please select a serving and quantity.")
                        }
                        
                    } else {
                        AlertManager.sharedInstance.whoopsSelectModifiers(self, title: "Whoops!", message: "Please select a serving and quantity.")
                    }
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        let parent = collectionView.superview!.tag
        
        // Details Table Row
        if parent == 0 {

        // Modifier Group Table Row
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverSGCollectionViewCell
            deselectedCell.label.textColor = UIColor.blackColor()
            deselectedCell.backgroundColor = UIColor.whiteColor()
            
            // IF HARVEST
            // ----------
            if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                
                let trueIndex = parent - 1
                
                let deselectedAddition = additions[trueIndex]
                
                var count = 0
                for productAdditionChoice in productAdditionChoices {
                    if productAdditionChoice.name == deselectedAddition.name {
                        productAdditionChoices.removeAtIndex(count)
                        count = 0
                    } else {
                        count = count + 1
                    }
                }
                
                print("------- UPDATED --------")
                print("ProductAdditionChoices: \(productAdditionChoices)")
                print("------- -- -- -- --------")
                
            } else {
                
                productChoice = Product()

                print("Product Choice has been set to: \(productChoice)")
                
            }
            
        // Quantity Table Row
        } else if parent == quantityRow {
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverQuantityCollectionViewCell
            deselectedCell.label.textColor = UIColor.blackColor()
            deselectedCell.backgroundColor = UIColor.whiteColor()
            
            quantityChoice = ""
            print("\(quantityChoice)")
          
        // Action Table Row
        } else if parent == actionRow {
            
        }
    }

    // Size Collection Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSize = CGSize()
        let parent = collectionView.superview!.tag
        
        // Details Table Row
        if parent == 0 {
            
        // SUBGROUPS: Subproduct and Additions Table Row
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let trueIndex = parent - 1
            var sgCellSize: CGSize!
            
            // ----- HARVEST BEGIN ------
            let numberOfModifiers: CGFloat!
            if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
                
                let trueIndex = parent - 1
                let numberOfValues = additions[trueIndex].values.count
                
                if numberOfValues > 3 {
                    numberOfModifiers = 3
                } else {
                    numberOfModifiers = CGFloat(additions[trueIndex].values.count)
                }
                
            } else {
                numberOfModifiers = CGFloat(subproducts.count)
            }
            // ----- END -----

            
            let trick = (numberOfModifiers - 1) * 10
            let spacing = (numberOfModifiers * 20) - trick
            
            let cellHeight = collectionView.bounds.size.height - 40
            let cellWidth = (collectionView.bounds.size.width - spacing) / numberOfModifiers
            
            sgCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return sgCellSize
            
        // Quantity Table Row
        } else if parent == quantityRow {
            var quantityCellSize: CGSize!
            let cellHeight = collectionView.bounds.size.height - 40
            let cellWidth = collectionView.bounds.size.width / 5
            
            quantityCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return quantityCellSize
            
        // Action Table Row
        } else if parent == actionRow {
            
            var actionCellSize: CGSize!
            let cellHeight = collectionView.bounds.size.height
            let cellWidth = (collectionView.bounds.size.width / 2) - 15
            
            actionCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return actionCellSize
            
        }
        
        return cellSize
        
    }
}