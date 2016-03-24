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
    var popoverAdditions = [PFObject]()
    var subproducts = [PFObject]()
    
    // Row QTY Data
    var rows: Int!
    var quantityRow: Int!
    var actionRow: Int!
    
    // Maximum Order Quantity
    var maxQuantity = 10
    
    // User Configuration
    var productChoices = [PFObject]()
    var quantityChoice = String()

// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("*****************************************")
//        print("Product passed to popover: \(popoverItem)")
//        print("Subproducts of this product are: \(subproducts)")
//        print("*****************************************")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    // TABLE DELEGATE AND DATA SOURCE
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            if route[1]["name"] as! String == "Harvest" {
                rows = popoverAdditions.count + 3
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

                if route[1]["name"] as! String == "Harvest" {
                    sgCell.servingLabel.text = popoverAdditions[trueIndex]["name"] as? String
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
                
                
                // IF HARVEST ------ BEGIN
                if route[1]["name"] as! String == "Harvest" {
                    subgroupCollectionCellCount = popoverAdditions.count
                // NOT HARVEST
                } else {
                    print("NEVER GONNA STOP NOOOOO: \(subproducts.count)")
                    subgroupCollectionCellCount = subproducts.count
                }
                // --------- END
                
                
                numberOfItems = subgroupCollectionCellCount

                
            // Quantity Table Row
            } else if parent == quantityRow {
                
                numberOfItems = maxQuantity

                
            // Action Table Row
            } else if parent == actionRow {
                
                numberOfItems = 2

                
            }
            
            print("NEVER GONNA STOP NOOOOO: \(numberOfItems)")
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

                // IF HARVEST
                // ------------ BEGIN
                if route[1]["name"] as! String == "Harvest" {

                    let productPortion = popoverAdditions[trueIndex]
                
                    let productPortionName = productPortion["name"] as? String
                    let productPortionPrice = productPortion["price"] as? Int
                    let productPriceDollar = (productPortionPrice! / 100)
                    let productPortionDollarString = String(productPriceDollar)
                
                    let orderAndServing = productPortionName! + "   " + productPortionDollarString
                    sgCollectionCell.label.text = orderAndServing
                
                // NOT HARVEST
                } else {
                    
                    let subproduct = subproducts[trueIndex]
                    
                    let subproductName = subproduct["name"] as? String
                    let subproductPrice = subproduct["price"] as? Int
                    let subproductDollar = (subproductPrice!)
                    let subproductDollarString = String(subproductDollar)
                    
                    let orderAndServing = subproductName! + "   " + subproductDollarString
                    sgCollectionCell.label.text = orderAndServing
                    
                }
                // -------------- END
                
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
            
            // IF HARVEST
            // ---------------- BEGIN
            if route[1]["name"] as! String == "Harvest" {
                
                let addition = popoverAdditions[indexPath.row]
                self.productChoices.append(addition)
                
                let trueIndex = productChoices.count - 1
                let additionName = productChoices[trueIndex]["name"]
                print("User chose to add: \(additionName)")
                
                
            // NOT HARVEST
            } else {
                
                let subproduct = subproducts[indexPath.row]
                self.productChoices.append(subproduct)
                
                let trueIndex = productChoices.count - 1
                let subproductName = productChoices[trueIndex]["name"]
                print("User chose to add: \(subproductName)")
                
                
            }
            // ---------------- END
            

        // Quantity Table Row
        } else if parent == quantityRow {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverQuantityCollectionViewCell
            selectedCell.layer.cornerRadius = 10.0
            selectedCell.clipsToBounds = true
            selectedCell.label.textColor = UIColor.whiteColor()
            selectedCell.backgroundColor = UIColor.blackColor()
            
            quantityChoice = selectedCell.label.text!
            print("User chose a quantity of: \(quantityChoice)")
            

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
                
                // IF HARVEST 
                // ---------- BEGIN
                if route[1]["name"] as! String == "Harvest" {
                    
                   completedChoices = popoverAdditions.count
                   
                // NOT HARVEST
                } else {
                    
                    completedChoices = 1
                    
                }
                
                
                
                // ----------- END
                
                
                if popoverItem != nil {
                    if productChoices.count == completedChoices {
                        if quantityChoice != "" {
                         
                            
                            // Create Modifiers To Add To LineItem
                            // -----------------------------------
                            // Func Req. = nil, Func Return = convertedProductChoices
                            var convertedProductChoices = [Product]()
                            
                            for choice in productChoices {
                                
                                var newSubproduct = Product()
                                newSubproduct.id = choice.objectId!
                                newSubproduct.lightspeedId = String(choice["lightspeedId"])
                                newSubproduct.name = choice["name"] as! String
                                
                                let productPrice = choice["price"] as! Double
                                newSubproduct.price = productPrice
                                
                                convertedProductChoices.append(newSubproduct)
                                print("Product convnerted to Subproduct: \(newSubproduct)")
                                                                
                            }
        
                            // -------------------------------
                            // -------------------------------
                            
                            // Begin Monetary Calculations
                            // --------------------------------------
                            // Add All Item Tax Rates Together
                            var totalTax = Double()
                            for taxRate in taxRates {
                                let rate = taxRate["rate"] as! Double
                                let rateToDollar = rate / 10000000   // TAX RATE DECIMAL CONVERSION
                                totalTax = totalTax + rateToDollar

                            }
                            
                            
                            // Calculate Tax Expenditure

                            let lineitemQuantity = Double(quantityChoice)
                            var preTaxedItem = Double()
                            var preTaxedItemTotal = Double()
                            
                            for newModifier in convertedProductChoices {
                                preTaxedItem = newModifier.price * lineitemQuantity!
                                preTaxedItemTotal = preTaxedItemTotal + preTaxedItem
                            }
                            
                            var lineitemTax = Double()
                            lineitemTax = preTaxedItemTotal * totalTax

                            
                            // Begin Create LineItem
                            // ------------------------------
                            // Func Req. = , Func Return =
                            var newLineItem = LineItem()
                            newLineItem.id = popoverItem.objectId!
                            newLineItem.lightspeedId = "\(popoverItem["lightspeedId"])"
                            newLineItem.name = popoverItem["name"] as! String
                            
                            // IF HARVEST
                            // ----------
                            // ADD: Varietal / Beer Style
                            let harvest = route[1]["name"] as! String
                            if harvest != "Harvest" {
                                newLineItem.varietal = popoverItemVarietal["name"] as! String
                            } else {
                                newLineItem.varietal = ""
                            }
                            
                            // ADD: Subproducts
                            newLineItem.subproducts = convertedProductChoices

                            newLineItem.price = preTaxedItemTotal
                            
                            newLineItem.quantity = Int(quantityChoice)!
                            newLineItem.tax = lineitemTax
                            
                            
                            print("New LineItem created: \(newLineItem.name)")
                            
                            // ------------------------------
                            // ------------------------------

                            
                            
                            
                            // Finalize: Add LineItem to Tab, Clean Up, Confirm
                            // ------------------------------
                            // Add LineItem to Tab
                            TabManager.sharedInstance.currentTab.lines.append(newLineItem)
                            print("Line Item \(newLineItem.name) has been added to currentTab.")
                            
                            // Clean Up
                            popoverAdditions.removeAll()
                            subproducts.removeAll()
                            
                            // Confirm
                            AlertManager.sharedInstance.addedSuccess(self, title: "Added Successfully", message: "Item has been added to your order!")
                            
                            print("*****************************************")
                            print("Product added to tab: \(newLineItem)")
                            print("*****************************************")

                            

                            
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
            
            let subproduct = subproducts[indexPath.row]
            
            if popoverAdditions.contains(subproduct) {
                
                productChoices = productChoices.filter() {$0 != subproduct}

            }
            
            let trueIndex = productChoices.count - 1
            let subproductName = subproduct["name"]
            print("Modifier \(subproductName) has been removed from selected modifiers.")

            
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
            
            // IF HARVEST
            // --------------- BEGIN
            let numberOfModifiers: CGFloat!
            if route[1]["name"] as! String == "Harvest" {
                numberOfModifiers = CGFloat(popoverAdditions.count)
            } else {
                numberOfModifiers = CGFloat(subproducts.count)
            }
            // --------------- END

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