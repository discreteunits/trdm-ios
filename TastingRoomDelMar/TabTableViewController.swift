//
//  TabTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

@objc
protocol TabTableViewDelegate {
    
}

class TabTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {

    // Table Cell Row Indicators
    var rows: Int!
    var totalRow: Int!
    var actionRow: Int!

    //
    var tab = TabManager.sharedInstance.currentTab
    
//    
//    // Protocol Delegate
//    var TabViewControllerRef: TabViewController?
//    var delegate: TabTableViewDelegate?
    
//    var containerViewController: TabViewController?

    @IBOutlet var tabTableView: UITableView!
    
    var TableNumberViewControllerRef: TableNumberViewController?
    
// --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tab.lines: \(tab.lines)")

        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
        // Scroll to bottom of table
        dispatch_async(dispatch_get_main_queue()) {
            let indexPath = NSIndexPath(forRow: self.actionRow, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("TabHeaderCell") as! TabHeaderTableViewCell
        
        headerCell.itemLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
        headerCell.qtyLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
        headerCell.priceLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
        
        return headerCell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        rows = calculateRows()
        
        return rows
        
    }
    
    func calculateRows() -> Int {
        var numberOfRows = TabManager.sharedInstance.currentTab.lines.count + 2
        totalRow = numberOfRows - 2
        actionRow = numberOfRows - 1
        
        return numberOfRows
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        // Line Item Table Row
        if indexPath.row < totalRow {
            
            var lineitemCell: TabLineItemTableViewCell
            lineitemCell = tableView.dequeueReusableCellWithIdentifier("TabLineItemTableCell", forIndexPath: indexPath) as! TabLineItemTableViewCell
  
            // Connect Specific Table Cell With Specific Colleciton View
            lineitemCell.contentView.tag = indexPath.row
            
            // Assignments
            lineitemCell.itemNameLabel?.text = "\(tab.lines[indexPath.row].name)"
            
            // Styles
            lineitemCell.itemNameLabel.font = UIFont(name: "BebasNeueRegular", size: 24)

            
            return lineitemCell

            
        // Total Table Row
        } else if indexPath.row == totalRow {
            
            var totalCell: TabTotalTableViewCell
            totalCell = tableView.dequeueReusableCellWithIdentifier("TabTotalTableCell", forIndexPath: indexPath) as! TabTotalTableViewCell
            
            // Assignments
            totalCell.subtotalValueLabel?.text = "\(tab.subtotal)"
            totalCell.taxValueLabel?.text = "\(tab.totalTax)"
            totalCell.totalValueLabel?.text = "\(tab.grandTotal)"
            
            // Styles
            totalCell.subtotalLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            totalCell.taxLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            totalCell.totalLabel.font = UIFont(name: "BebasNeueRegular", size: 18)
            
            totalCell.subtotalValueLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            totalCell.taxValueLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            totalCell.totalValueLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
            
            
            return totalCell

            
        // Action Table Row
        } else if indexPath.row == actionRow {
            
            var actionCell: TabActionTableViewCell
            
            actionCell = tableView.dequeueReusableCellWithIdentifier("TabActionTableCell", forIndexPath: indexPath) as! TabActionTableViewCell

            // Styles
            actionCell.placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
            actionCell.placeOrderButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 28)
            actionCell.placeOrderButton.layer.cornerRadius = 6.0
            actionCell.placeOrderButton.clipsToBounds = true
            actionCell.placeOrderButton.titleLabel?.textColor = UIColor.whiteColor()
            
            return actionCell

            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            var tableViewCell: UITableViewCell!
            
            // Lineitem Table Row
            if indexPath.row < totalRow {
                
                guard let tableViewCell = cell as? TabLineItemTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
                
            // Total Table Row
            } else if indexPath.row == totalRow {
                
                guard let tableViewCell = cell as? TabTotalTableViewCell else { return }
                
            // Action Table Row
            } else if indexPath.row == actionRow {
                
                guard let tableViewCell = cell as? TabActionTableViewCell else { return }
                
            }
            
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cellSize: CGFloat!

        if indexPath.row < totalRow {
            if tab.lines.count > 0 {
                let lineMods = tab.lines[indexPath.row].modifiers.count
                let lineSize = lineMods * 25 + 50
            
                return CGFloat(lineSize)
            }
            
            return 0
            
        } else if indexPath.row == totalRow {
            
            return 100
            
        } else if indexPath.row == actionRow {

            return 100
            
        }
        
        return cellSize

    }


    
// ---------- Begin Delete LineItem


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        // LineItem Row
        if indexPath.row < totalRow {
            return true
        // Total Row
        } else if indexPath.row == totalRow {
            return false
        // Action Row
        } else if indexPath.row == actionRow {
            return false
        }
        
        return false
        
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            tableView.beginUpdates()
            
            TabManager.sharedInstance.currentTab.lines.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths(NSArray(object: NSIndexPath(forRow: indexPath.row, inSection: 0)) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Left)

            tableView.endUpdates()

            
            self.tableView.reloadData()

   
        }
        
        rows = calculateRows()
        TabManager.sharedInstance.totalCellCalculator()

    }
//    
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        tableView.beginUpdates()
//    }
//    
//    
//    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        
//        if type == .Delete {
//            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//        }
//    }
//    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        
//        if type == .Delete {
//            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//        }
//    }
//    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        tableView.endUpdates()
//    }
//    
// ---------------------
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get Screen Size
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        
        // Enter Table Number Popover
        if segue.identifier == "enterTableNumber" {
            
            let vc = segue.destinationViewController as! TableNumberViewController
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight*0.4)
            
            // Data To Be Passed
            
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller?.delegate = self
            }
            
            // Protocol or GratuitySegue
            self.TableNumberViewControllerRef = vc
            vc.delegate = self
            
        }
        
        // Add Gratuity Popover
        if segue.identifier == "addGratuity" {
            let vc = segue.destinationViewController as! AddGratuityViewController
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight * 0.53)
            
            // Data To Be Passed
            
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller?.delegate = self
            }
            
        }
        
    }
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

}

// Extension for protocol in Table Number Popover
extension TabTableViewController: TableNumberViewDelegate {
    
    func gratuitySegue() {
        performSegueWithIdentifier("addGratuity", sender: self)
    }
    
}

// -----------------------------------
// COLLECTION DELEGATE AND DATA SOURCE
// -----------------------------------
extension TabTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let parent = collectionView.superview!.tag
        var numberOfItems: Int!

        if parent < totalRow {
            
            let modChoices = TabManager.sharedInstance.currentTab.lines[0].modifiers.count
            numberOfItems = modChoices
            
        }
        
        return numberOfItems
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        let parent = collectionView.superview!.tag
        
        if parent < totalRow {
            
            // Serving Modifier Collection Row
            if indexPath.row == 0 {
                
                var lineitemServingCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemServingCollectionCell", forIndexPath: indexPath) as! TabLineItemServingCollectionViewCell

                // Assignments
                //// Declare Pair for Presentation
                let orderMod = TabManager.sharedInstance.currentTab.lines[parent].modifiers[indexPath.row].name
                let servingPrice = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].modifiers[indexPath.row].price))"
                let orderAndServing = orderMod + "   " + servingPrice
                lineitemServingCollectionCell.servingSizeLabel?.text = "\(orderAndServing)"
                
                lineitemServingCollectionCell.qtyLabel?.text = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].quantity))"
                
                lineitemServingCollectionCell.priceLabel?.text = "\(Int(TabManager.sharedInstance.currentTab.lines[parent].price))"

                
                // Styles
                lineitemServingCollectionCell.backgroundColor = UIColor.whiteColor()
                lineitemServingCollectionCell.servingSizeLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                lineitemServingCollectionCell.qtyLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                lineitemServingCollectionCell.priceLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                
                return lineitemServingCollectionCell
                
                
            // All Other Modifier Colleciton Rows
            } else {
               
                var lineitemCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("TabLineItemCollectionCell", forIndexPath: indexPath) as! TabLineItemCollectionViewCell
                
                // Assignment
                lineitemCollectionCell.modNameLabel?.text = "\(TabManager.sharedInstance.currentTab.lines[parent].modifiers[indexPath.row].name)"
                
                // Styles
                lineitemCollectionCell.backgroundColor = UIColor.whiteColor()
                lineitemCollectionCell.modNameLabel.font = UIFont(name: "NexaRustScriptL-00", size: 18)
                
                return lineitemCollectionCell
                
            }
            
        }
        
        return cell
        
    }
    
    
    // Size Collection Cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cellSize: CGSize!
        let parent = collectionView.superview!.tag
        
        if parent < totalRow {

            var collectionLineSize: CGSize!
            
            let cellWidth = collectionView.bounds.size.width - 10
            let cellHeight = CGFloat(25)
            
            collectionLineSize = CGSize(width: cellWidth, height: cellHeight)
            
            return collectionLineSize
            
        } else if parent == totalRow {
            
            // Do nothing
            
        } else if parent == actionRow {
            
            // Do nothing
            
        }
        
        return cellSize
        
    }
    
    
// CLOUDCODE PLACEORDER
    @IBAction func placeOrder(sender: AnyObject) {
        
        // Checkout Options
        if TabManager.sharedInstance.currentTab.checkoutMethod == "" {
            checkoutOptions("Checkout Options", message: "Please select your desired checkout method below.")
        
        // If User already selected checkout option of stripe
        } else if TabManager.sharedInstance.currentTab.checkoutMethod == "stripe" {
            self.stripeCheckout()
        }

    }
    
    func stripeCheckout() {
        
        // Whoops Logged In
        if tab.userId == "" {
            whoopsLoggedInAlert("Whoops", message: "Looks like you're not logged in or don't have an account. Login or create an account to place an order.")
        }
        
        // Whoops Credit Card
        if CardManager.sharedInstance.currentCustomer.card.brand == "" {
            whoopsCreditCardAlert("Whoops", message: "Looks like you don't have a credit card on file. Please add a card or checkout with your servers.")
        }
        
        // Enter Table Number
        if TabManager.sharedInstance.currentTab.table == "" {
            performSegueWithIdentifier("enterTableNumber", sender: self)
        }
        
        // Add Gratuity
        if (TabManager.sharedInstance.currentTab.gratuity.doubleValue != nil) {
            performSegueWithIdentifier("addGratuity", sender: self)
        }

    }
    
    
// ------------- Begin Alerts ----------
    
    //// CheckoutOptions
    @available(iOS 8.0, *)
    func checkoutOptions(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let loginAction = UIAlertAction(title: "Closeout now ", style: .Default, handler: { (action) -> Void in
            TabManager.sharedInstance.currentTab.checkoutMethod = "stripe"
            
            // Continue Place Order
            self.stripeCheckout()
            
            print("Closeout Now Selected")
        })
        let createAccountAction = UIAlertAction(title: "Closeout later with your Server", style: .Default , handler: { (action) -> Void in
            self.tab.checkoutMethod = "server"
            print("Closeout Later Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(loginAction)
        alert.addAction(createAccountAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //// WhoopsLoggedIn
    @available(iOS 8.0, *)
    func whoopsLoggedInAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let loginAction = UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
            self.goToLogIn()
            print("Login Selected")
        })
        let createAccountAction = UIAlertAction(title: "Create Account", style: .Default , handler: { (action) -> Void in
            self.goToLogIn()
            print("Create Account Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(loginAction)
        alert.addAction(createAccountAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    //// WhoopsCreditCard
    @available(iOS 8.0, *)
    func whoopsCreditCardAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let addCardAction = UIAlertAction(title: "Add Card", style: .Default, handler: { (action) -> Void in
            self.goToAddPayment()
            print("Add Card Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(addCardAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func goToLogIn() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("createAccount")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func goToAddPayment() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("addPayment")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}
