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
import SwiftyJSON

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
    var productChoices = [Product]() // Beer and Wine
    var productHarvestChoices = [Addition]() // Harvest
    var quantityChoice = String()
    
    // Collect All Additions For This Item
    var additions:[Addition] = [Addition]()
    

// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        createAdditions()
   
    }
    
    func createAdditions() {
        
        // Create Additions with Values
        for var i = 0; i < popoverAdditions.count; ++i {
            
            let additionValues = popoverAdditions[i]["values"]
            
            var convertedAdditionValues: [Value] = [Value]()
            
            for value in additionValues as! [[String:AnyObject]] {
                
                var newValue = Value()
                newValue.id = String(value["id"]!)
                newValue.info = value["info"] as! String
                newValue.name = value["name"] as! String
                newValue.price = String(value["price"]!)
                newValue.priceWithoutVAT = String(value["priceWithoutVAT"]!)
                
                convertedAdditionValues.append(newValue)
                
            }
            
            let additionRaw = popoverAdditions[i]
            
            var newAddition = Addition()
            newAddition.displayName = additionRaw["displayName"] as! String
            newAddition.id = String(additionRaw["id"]!)
            newAddition.maxSelectedAmount = String(additionRaw["maxSelectedAmount"]!)
            newAddition.minSelectedAmount = String(additionRaw["minSelectedAmount"]!)
            newAddition.name = additionRaw["name"] as! String
            newAddition.values = convertedAdditionValues
            
            self.additions.append(newAddition)
            
        }
        
    }
    
    // TABLE DELEGATE AND DATA SOURCE
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            if route[1]["name"] as! String == "Harvest" {
                rows = additions.count + 3
            } else {
                rows = 4
            }
            
            quantityRow = rows - 2
            actionRow = rows - 1
                        
            return rows
            
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            var cell: UITableViewCell!
            
            // Details Table Row
            if indexPath.row == 0 {
                
                var detailsCell: PopoverDetailsTableViewCell
                detailsCell = tableView.dequeueReusableCellWithIdentifier("PopoverDetailsTableCell",
                    forIndexPath: indexPath) as! PopoverDetailsTableViewCell
                
                detailsCell.contentView.tag = indexPath.row
                detailsCell.selectionStyle = UITableViewCellSelectionStyle.None

                detailsCell.titleLabel?.text = popoverItem["name"] as! String!
                detailsCell.titleLabel.font = UIFont.headerFont(24)
                detailsCell.altNameTextView?.text = popoverItem["info"] as! String!
                detailsCell.altNameTextView.font = UIFont.basicFont(12)
                
                // Adjustment For Text View Text Wrapping ---- BEGIN
                detailsCell.altNameTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
                detailsCell.altNameTextView.contentInset = UIEdgeInsets(top: -12, left: -5, bottom: 0, right: 0)
                detailsCell.altNameTextView?.sizeToFit()
                detailsCell.altNameTextView.scrollEnabled = false
                // ----------- END
                
                detailsCell.varietalLabel.font = UIFont.basicFont(16)
                // IF HARVEST
                if route[1]["name"] as! String == "Harvest" {
                    detailsCell.varietalLabel?.text = ""
                } else {
                    if let varietalName = popoverItemVarietal["name"] as? String {
                        detailsCell.varietalLabel?.text = varietalName
                    }
                }
                
                return detailsCell
                
            // Additions And Subproducts Table Row
            } else if (indexPath.row > 0) && (indexPath.row < quantityRow) {
                
                var sgCell: PopoverSGTableViewCell
                sgCell = tableView.dequeueReusableCellWithIdentifier("PopoverSGTableCell",
                    forIndexPath: indexPath) as! PopoverSGTableViewCell
                sgCell.contentView.tag = indexPath.row
                
                let trueIndex = indexPath.row - 1
                
                sgCell.servingLabel.layer.zPosition = 100
                sgCell.servingLabel.font = UIFont.headerFont(18)

                
                // IF HARVEST
                if route[1]["name"] as! String == "Harvest" {
                    
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
                qtyCell.label.font = UIFont.headerFont(18)
                
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
            
            var tableViewCell: UITableViewCell!
            
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

}


// -----------------------------------
// COLLECTION DELEGATE AND DATA SOURCE
// -----------------------------------
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
                if route[1]["name"] as! String == "Harvest" {
                    
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
            
            var cell: UICollectionViewCell!
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
                sgCollectionCell.label.font = UIFont.scriptFont(14)
                
                let trueIndex = parent - 1

                // ----- HARVEST BEGIN ------
                if route[1]["name"] as! String == "Harvest" {
                    
                    sgCollectionCell.label.text = additions[trueIndex].values[indexPath.row].name
                
                } else {
                    
                    let subproduct = subproducts[indexPath.row]
                    
                    let subproductPrice = subproduct.price 
                    let subproductDollar = (Int(subproductPrice))
                    let subproductDollarString = String(subproductDollar)
                    
                    let orderAndServing = subproduct.info + "   " + subproductDollarString
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
                
                var trueIndex = String(indexPath.row + 1)
                quantityCollectionCell.label.text = trueIndex
                quantityCollectionCell.label.font = UIFont.scriptFont(14)
                
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
        let selectedCell: UICollectionViewCell

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
            if route[1]["name"] as! String == "Harvest" {
                
                let trueIndex = parent - 1

                var selectedAddition = Addition()
                
                selectedAddition = additions[trueIndex]
                selectedAddition.values.removeAll()
                selectedAddition.values.append(additions[trueIndex].values[indexPath.row])
                
                if printFlag {
                    print("Selected Addition with Value: \(selectedAddition)")
                }
                
                productHarvestChoices.append(selectedAddition)
                
            } else {
                
                let subproduct = subproducts[indexPath.row]
                self.productChoices.append(subproduct)
                
                let trueIndex = productChoices.count - 1
                
                let subproductName = productChoices[trueIndex].name
                if printFlag {
                    print("User chose to add: \(subproductName)")
                }
                
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
                if route[1]["name"] as! String == "Harvest" {
                    
                   completedChoices = popoverAdditions.count
                   
                } else {
                    
                    completedChoices = 1
                    
                }
                // ----- END -----
                
                if popoverItem != nil {
                    if productChoices.count == completedChoices || productHarvestChoices.count == completedChoices {
                        if quantityChoice != "" {
                         
//                            // Create Modifiers To Add To LineItem
//                            // -----------------------------------
//                            var convertedProductChoices = [Product]()
//                            
//                            for choice in productChoices {
//                                
//                                var newSubproduct = Product()
//                                newSubproduct.id = choice.objectId!
//                                newSubproduct.lightspeedId = String(choice["lightspeedId"])
//                                newSubproduct.name = choice["name"] as! String
//                                
//                                let productPrice = choice["price"] as! Double
//                                newSubproduct.price = productPrice
//                                
//                                convertedProductChoices.append(newSubproduct)
//                                
//                                if printFlag {
//                                    print("Product convnerted to Subproduct: \(newSubproduct)")
//                                }
//                                
//                            }
                            
                            // Begin Monetary Calculations
                            // --------------------------------------
                            var taxString = popoverItem["taxClass"] as! String
                            
                            let taxRateString = taxString.stringByReplacingOccurrencesOfString("BUILTIN-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            
                            let taxRateConversion = Double(taxRateString)! / 100
                            let taxRateDouble = taxRateConversion
                            
                            if printFlag {
                                print("\(taxRateDouble)")
                            }
                            
                            // Calculate Tax Expenditure
                            let lineitemQuantity = Double(quantityChoice)
                            
                            // Total All Subproduct Choice Prices
                            var totalChoicesPrice = Double()
                            for choice in productChoices {
                                totalChoicesPrice = totalChoicesPrice + choice.price
                            }
                            
                            let lineitemPreTax = lineitemQuantity! * (totalChoicesPrice)
                            
                            let lineitemTax = lineitemPreTax * taxRateDouble
                            
                            let lineitemTotal = lineitemTax + lineitemPreTax
                            
                            if printFlag {
                                print("+++++++++++++++++++++++++++++++++++")
                                print("Tax String: \(popoverItem["taxClass"])")
                                print("Line Item Pre Tax: \(lineitemPreTax)")
                                print("Line Item Tax Calculated to: \(lineitemTax)")
                                print("Line Item Total: \(lineitemTotal)")
                                print("+++++++++++++++++++++++++++++++++++")
                            }
                            
                            // Begin Create LineItem
                            // ------------------------------
                            var newLineItem = LineItem()
                            newLineItem.id = popoverItem.objectId!
                            newLineItem.lightspeedId = "\(popoverItem["lightspeedId"])"
                            newLineItem.name = popoverItem["name"] as! String
                            newLineItem.additions = productHarvestChoices
                            
                            
                            // ----- HARVEST BEGIN ------
                            if route[1]["name"] as! String == "Harvest" {
                                newLineItem.varietal = ""
                            } else {
                                newLineItem.varietal = popoverItemVarietal["name"] as! String
                            }
                            // ----- END -----
                            
                            
                            // ADD: Subproducts
                            newLineItem.subproducts = productChoices
                            newLineItem.price = lineitemPreTax
                            newLineItem.quantity = Int(quantityChoice)!
                            newLineItem.tax = lineitemTax
                            
                            
                            // CREATE PRODUCT FROM POPOVER ITEM
                            var newProduct = Product()
                            newProduct.id = popoverItem.objectId!
                            newProduct.lightspeedId = String(popoverItem["lightspeedId"])
                            newProduct.name = popoverItem["name"] as! String
                            
                            let newProductPrice = popoverItem["price"] as! Double
                            newProduct.price = newProductPrice

                            newLineItem.product = newProduct
                            
                            
                            // ----- HARVEST BEGIN ------
                            if route[1]["name"] as! String == "Harvest" {
                                newLineItem.eatOrDrink = "Eat"
                            } else {
                                newLineItem.eatOrDrink = "Drink"
                            }
                            // ----- END -----
                            
                            if printFlag {
                                print("New LineItem created: \(newLineItem.name)")
                            }

                            // Finalize: Add LineItem to Tab, Clean Up, Confirm
                            // ------------------------------
                            // Add LineItem to Tab
                            TabManager.sharedInstance.currentTab.lines.append(newLineItem)
                            
                            if printFlag {
                                print("Line Item \(newLineItem.name) has been added to currentTab.")
                            }
                            
                            // Clean Up
                            popoverAdditions.removeAll()
                            subproducts.removeAll()
                            productHarvestChoices.removeAll()
                            productChoices.removeAll()
                            taxRates.removeAll()
                            
                            
                            // Confirm
                            AlertManager.sharedInstance.addedSuccess(self, title: "Added Successfully", message: "Item has been added to your order!")
                            
                            if printFlag {
                                print("*****************************************")
                                print("Product added to tab: \(newLineItem)")
                                print("*****************************************")
                            }
                            
                        } else {
                            AlertManager.sharedInstance.whoopsSelectModifiers(self, title: "Whoops", message: "Please select a modifier and quantity.")
                        }
                        
                    } else {
                        AlertManager.sharedInstance.whoopsSelectModifiers(self, title: "Whoops", message: "Please select a modifier and quantity.")
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
            if route[1]["name"] as! String == "Harvest" {
                
                let trueIndex = parent - 1
                
                
                let deselectedAddition = additions[trueIndex]
                
                var count = 0
                for productHarvestChoice in productHarvestChoices {
                    if productHarvestChoice.name == deselectedAddition.name {
                        productHarvestChoices.removeAtIndex(count)
                        count = 0
                    } else {
                        count = count + 1
                    }
                }
                
                if printFlag {
                    print("------- UPDATED --------")
                    print("ProductHarvestChoices: \(productHarvestChoices)")
                    print("------- -- -- -- --------")
                }
                    
            } else {
                
//                let subproduct = subproducts[indexPath.row]
//                
//                if productChoices.contains(subproduct) {
//                    
//                    productChoices = productChoices.filter() {$0 != subproduct}
//                    
//                }
                
                let trueIndex = parent - 1
                
                let deselectedSubproduct = productChoices[trueIndex]
                
                var count = 0
                for productChoice in productChoices {
                    if productChoice.name == deselectedSubproduct.name {
                        productChoices.removeAtIndex(count)
                        count = 0
                    } else {
                        count = count + 1
                    }
                }
                
                
                
                let subproductName = deselectedSubproduct.name
                if printFlag {
                    print("Modifier \(subproductName) has been removed from selected modifiers.")
                }
                
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
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverActionCollectionViewCell
            
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {

            }
            
        }
        
    }

    // Size Collection Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cellSize: CGSize!
        let parent = collectionView.superview!.tag
        
        // Details Table Row
        if parent == 0 {

        // SUBGROUPS: Subproduct and Additions Table Row
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let trueIndex = parent - 1
            var sgCellSize: CGSize!
            
            
            // ----- HARVEST BEGIN ------
            let numberOfModifiers: CGFloat!
            if route[1]["name"] as! String == "Harvest" {
                
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
            let cellHeight = collectionView.bounds.size.height - 40
            let cellWidth = (collectionView.bounds.size.width / 2) - 15
            
            actionCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return actionCellSize
            
        }
        
        return cellSize
        
    }

}


