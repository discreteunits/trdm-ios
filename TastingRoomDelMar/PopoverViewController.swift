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
    
    // Received data based on table selection
    var popoverItem: PFObject!
    var popoverItemVarietal: PFObject!
    var modGroups = [PFObject]()
    var modGroupDict = [[PFObject]]()
    var taxRates = [PFObject]()
    
    // Data built in this controller
    var modifierObjects = [PFObject]()
    
    var rows: Int!
    var quantityRow: Int!
    var actionRow: Int!
    
    // Maximum Item Order Quantity
    var maxQuantity = 10
    
    
    // User Configuration
    var modChoices = [PFObject]()
    var quantityChoice = String()
    // item to pass is popoverItem
    
    // Model Row Collections
    var model = [[PFObject]]()


// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createModels(modGroupDict)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func createModels(dictionary:[[PFObject]]) {
       
        // Details Row
        model.append([])
        
        // All Modifier Group Rows
        for var index = 0; index < modGroupDict.count; ++index {
            
            model.append(modGroupDict[index])
            
        }
        
        // Quantity Row
        model.append([])
        
        // Action Row
        model.append([])
        
        print("Model has been created.")

    }
    

    
    
// TABLE DELEGATE AND DATA SOURCE
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            rows = modGroups.count + 3
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
                detailsCell.titleLabel?.text = popoverItem["name"] as! String!
                detailsCell.titleLabel.font = UIFont(name: "BebasNeueRegular", size: 24)
                detailsCell.altNameLabel?.text = popoverItem["alternateName"] as! String!
                detailsCell.altNameLabel.font = UIFont(name: "OpenSans", size: 16)
                detailsCell.varietalLabel?.text = popoverItemVarietal["name"] as! String!
                detailsCell.varietalLabel.font = UIFont(name: "OpenSans", size: 16)

                detailsCell.selectionStyle = UITableViewCellSelectionStyle.None

                return detailsCell
                
            // Modifier Group Table Row
            } else if (indexPath.row > 0) && (indexPath.row < quantityRow) {
                
                var mgCell: PopoverMGTableViewCell
                mgCell = tableView.dequeueReusableCellWithIdentifier("PopoverMGTableCell",
                    forIndexPath: indexPath) as! PopoverMGTableViewCell
                mgCell.contentView.tag = indexPath.row
                
                let trueIndex = indexPath.row - 1
                
                mgCell.servingLabel.layer.zPosition = 100
                mgCell.servingLabel.text = modGroups[trueIndex]["name"] as? String
                mgCell.servingLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

                
                return mgCell
                
            // Quantity Table Row
            } else if indexPath.row == quantityRow {
                
                var qtyCell: PopoverQuantityTableViewCell
                qtyCell = tableView.dequeueReusableCellWithIdentifier("PopoverQuantityTableCell",
                    forIndexPath: indexPath) as! PopoverQuantityTableViewCell
                qtyCell.contentView.tag = indexPath.row
                qtyCell.label.text = "quantity"
                qtyCell.label.font = UIFont(name: "BebasNeueRegular", size: 18)

                
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
                
            // Modifier Group Table Row
            } else if (indexPath.row > 0) && (indexPath.row < quantityRow ) {
                
                guard let tableViewCell = cell as? PopoverMGTableViewCell else { return }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
                
            // Modifier Group Table Row
            } else if (parent > 0) && (parent < quantityRow ) {
                
                let trueIndex = parent - 1
                
                let modCollecitonCellCount = modGroups[trueIndex]["modifiers"].count
                
                numberOfItems = modCollecitonCellCount

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

            // Modifier Group Table Row
            } else if (parent > 0) && (parent < quantityRow ) {
                
                var mgCollectionCell: PopoverMGCollectionViewCell
                mgCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverMGCollectionCell",
                    forIndexPath: indexPath) as! PopoverMGCollectionViewCell
                
                mgCollectionCell.backgroundColor = UIColor.whiteColor()
                
                // Find modifiers and populate cells
                let trueIndex = parent - 1
                var itemPortion = modGroupDict[trueIndex]
                
                let itemPortionObject = itemPortion[indexPath.row]
                let itemPortionObjectName = itemPortionObject["name"] as? String
                let itemPortionObjectPrice = itemPortionObject["price"] as? Int
                let itemPriceDollar = (itemPortionObjectPrice! / 100)
                let itemPortionPrice = String(itemPriceDollar)
                
                // Pair Modifier Name With Price
                let orderAndServing = itemPortionObjectName! + "   " + itemPortionPrice
                
                mgCollectionCell.label.text = orderAndServing
                mgCollectionCell.label.font = UIFont(name: "NexaRustScriptL-00", size: 14)
                
                
                mgCollectionCell.layer.borderWidth = 2
                mgCollectionCell.layer.borderColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
                mgCollectionCell.layer.cornerRadius = 10.0
                mgCollectionCell.clipsToBounds = true

                
                return mgCollectionCell
                
            // Quantity Table Row
            } else if parent == quantityRow {
                
                var quantityCollectionCell: PopoverQuantityCollectionViewCell
                quantityCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("PopoverQuantityCollectionCell",
                    forIndexPath: indexPath) as! PopoverQuantityCollectionViewCell
                
                quantityCollectionCell.backgroundColor = UIColor.whiteColor()
                
                var trueIndex = String(indexPath.row + 1)
                quantityCollectionCell.label.text = trueIndex
                quantityCollectionCell.label.font = UIFont(name: "NexaRustScriptL-00", size: 14)
                
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
                
                actionCollectionCell.label.font = UIFont(name: "NexaRustScriptL-00", size: 20)
                actionCollectionCell.layer.cornerRadius = 6.0
                actionCollectionCell.clipsToBounds = true
                
                // Cancel
                if indexPath.row == 0 {
                    
                    actionCollectionCell.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
                    actionCollectionCell.label.textColor = UIColor.blackColor()
                    actionCollectionCell.label.text = "Cancel"
                    
                // Add to Tab
                } else if indexPath.row == 1 {
                    
                    actionCollectionCell.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
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
            
        // Modifier Group Table Row
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverMGCollectionViewCell
            selectedCell.layer.cornerRadius = 10.0
            selectedCell.clipsToBounds = true
            selectedCell.label.textColor = UIColor.whiteColor()
            selectedCell.backgroundColor = UIColor.blackColor()
            
            let mod = model[parent][indexPath.row]
            
            // Add chosen modifier to modChoices array.
            self.modChoices.append(mod)
            
            let trueIndex = modChoices.count - 1
            let modName = modChoices[trueIndex]["name"]
            print("User chose a modifier of: \(modName)")
            

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
            
            // Cancel
            if indexPath.row == 0 {
                
                // Revert view controllers, views, and collections back to pre-popover state
                self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
                
                let tierIVView = self.presentingViewController!.view
                if let viewWithTag = tierIVView!.viewWithTag(21) {
                    
                    viewWithTag.removeFromSuperview()
                }
                

            // Add to Tab
            } else if indexPath.row == 1 {
                
                if popoverItem != nil {
                    if modChoices.count == modGroups.count {
                        if quantityChoice != "" {
                         
                            
                            // Create Modifiers
                            // ------------------------------
                            var convertedModChoices = [Modifier]()
                            
                            for modifier in modChoices {
                                
                                var newModifier = Modifier()
                                newModifier.id = modifier.objectId!
                                newModifier.cloverId = modifier["cloverId"] as! String
                                newModifier.name = modifier["name"] as! String
                                
                                let modPrice = modifier["price"] as! Double
                                newModifier.price = modPrice / 100
                                
                                convertedModChoices.append(newModifier)
                                print("Mod convnerted to Modifier: \(newModifier)")
                                                                
                            }
                            
     
                            // Add All Item Tax Rates Together
                            var totalTax = Double()
                            for taxRate in taxRates {
                                let rate = taxRate["rate"] as! Double
                                let rateToDollar = rate / 10000000                // TAX RATE DECIMAL CONVERSION
                                totalTax = totalTax + rateToDollar
                                

                            }
                            
                            
                            // Calculate Tax Expenditure

                            let lineitemQuantity = Double(quantityChoice)
                            var preTaxedItem = Double()
                            var preTaxedItemTotal = Double()
                            
                            for newModifier in convertedModChoices {
                                preTaxedItem = newModifier.price * lineitemQuantity!
                                preTaxedItemTotal = preTaxedItemTotal + preTaxedItem
                            }
                            
                            var lineitemTax = Double()
                            lineitemTax = preTaxedItemTotal * totalTax

                            
                            // Create LineItem
                            // ------------------------------
                            var newLineItem = LineItem()
                            newLineItem.id = popoverItem.objectId!
                            newLineItem.cloverId = popoverItem["cloverId"] as! String
                            newLineItem.name = popoverItem["name"] as! String
                            newLineItem.varietal = popoverItemVarietal["name"] as! String
                            newLineItem.modifiers = convertedModChoices

                            newLineItem.price = preTaxedItemTotal
                            
                            newLineItem.quantity = Int(quantityChoice)!
                            newLineItem.tax = lineitemTax
                            
                            
                            print("New LineItem created: \(newLineItem.name)")
                            
                            // Add LineItem to TabManager tab() Structure
                            TabManager.sharedInstance.currentTab.lines.append(newLineItem)
                            print("Line Item \(newLineItem.name) has been added to currentTab.")
                                                        
                            
                            // Revert view controllers, views, and collections back to pre-popover state
                            self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
                            
                            let tierIVView = self.presentingViewController!.view
                            if let viewWithTag = tierIVView!.viewWithTag(21) {
                                
                                viewWithTag.removeFromSuperview()
                            }
                            
                            
                            // Clean Up
                            modGroups.removeAll()
                            modGroupDict.removeAll()
                            model.removeAll()
                            
                        }
                        
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
            
            let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! PopoverMGCollectionViewCell
            deselectedCell.label.textColor = UIColor.blackColor()
            deselectedCell.backgroundColor = UIColor.whiteColor()
            
            let mod = model[parent][indexPath.row]
            
            if modChoices.contains(mod) {
                
                modChoices = modChoices.filter() {$0 != mod}

            }
            
            let trueIndex = modChoices.count - 1
            let modName = mod["name"]
            print("Modifier \(modName) has been removed from selected modifiers.")

            
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

        // Modifier Group Table Row
        } else if (parent > 0) && (parent < quantityRow ) {
            
            let trueIndex = parent - 1
            var mgCellSize: CGSize!
            let numberOfModifiers = CGFloat(modGroups[trueIndex]["modifiers"].count)

            let trick = (numberOfModifiers - 1) * 10
            let spacing = (numberOfModifiers * 20) - trick
            
            let cellHeight = collectionView.bounds.size.height - 40
            let cellWidth = (collectionView.bounds.size.width - spacing) / numberOfModifiers
            
            mgCellSize = CGSize(width: cellWidth, height: cellHeight)
            
            return mgCellSize
            
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
    
    func opaqueWindow() {
        
        let tierIVView = self.view
        
        let windowWidth = self.view.bounds.size.width
        let windowHeight = self.view.bounds.size.height
        
        let windowView = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        
        if let viewWithTag = tierIVView.viewWithTag(21) {
            
            viewWithTag.removeFromSuperview()
            
        } else {
            
            windowView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
            windowView.tag = 21
            tierIVView.addSubview(windowView)
            
        }
        
    }
    
}


