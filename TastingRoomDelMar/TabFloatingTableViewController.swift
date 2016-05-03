//
//  TabFloatingTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/21/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

@objc
protocol TabFloatingTableViewDelegate {
    func defaultScreen()
    func getView() -> UIView
    func getController() -> UIViewController
    func recalculateLineItems()
}

class TabFloatingTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var TableNumberViewControllerRef: TableNumberViewController?
    var AddGratuityViewControllerRef: AddGratuityViewController?
    
    // Price Formatter
    let formatter = PriceFormatManager.priceFormatManager
    
    var delegate: TabFloatingTableViewDelegate?
    
    var tabView = UIView()
    var tabController = UIViewController()
    
    // -----
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
        TabManager.sharedInstance.totalCellCalculator()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.alwaysBounceVertical = false
        self.tableView.scrollEnabled = false 
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        
        tabView = (delegate?.getView())!
        tabController = (delegate?.getController())!
        
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        if indexPath.row == 0 {
            
            var totalCell: TabTotalTableViewCell
            totalCell = tableView.dequeueReusableCellWithIdentifier("TabTotalTableCell", forIndexPath: indexPath) as! TabTotalTableViewCell
            
            // Connect Specific Table Cell With Specific Colleciton View
            totalCell.contentView.tag = indexPath.row
            
            
            // Assignments
            let subTotal = TabManager.sharedInstance.currentTab.subtotal
            let convertedSubtotal = formatter.formatPrice(subTotal)
            totalCell.subtotalValueLabel?.text = convertedSubtotal
            
            
            let totalTax = TabManager.sharedInstance.currentTab.totalTax
            let convertedTotalTax = formatter.formatPrice(totalTax)
            totalCell.taxValueLabel?.text = convertedTotalTax
            
            
            let grandTotal = TabManager.sharedInstance.currentTab.grandTotal
            let convertedGrandTotal = formatter.formatPrice(grandTotal)
            totalCell.totalValueLabel?.text = convertedGrandTotal
            
            
            // Styles
            totalCell.subtotalLabel?.font = UIFont.headerFont(18)
            totalCell.taxLabel?.font = UIFont.headerFont(18)
            totalCell.totalLabel?.font = UIFont.headerFont(18)
            
            totalCell.subtotalValueLabel?.font = UIFont.scriptFont(18)
            totalCell.taxValueLabel?.font = UIFont.scriptFont(18)
            totalCell.totalValueLabel?.font = UIFont.scriptFont(18)
            
            totalCell.selectionStyle = UITableViewCellSelectionStyle.None

            
            return totalCell
            
        } else if indexPath.row == 1 {
            
            var actionCell: TabActionTableViewCell
            
            actionCell = tableView.dequeueReusableCellWithIdentifier("TabActionTableCell", forIndexPath: indexPath) as! TabActionTableViewCell
            
            // Connect Specific Table Cell With Specific Colleciton View
            actionCell.contentView.tag = indexPath.row
            
            // Styles
            actionCell.placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
            actionCell.placeOrderButton.titleLabel?.font = UIFont.scriptFont(28)
            actionCell.placeOrderButton.tintColor = UIColor.whiteColor()
            actionCell.placeOrderButton.layer.cornerRadius = 6.0
            actionCell.placeOrderButton.clipsToBounds = true
            actionCell.placeOrderButton.titleLabel?.textColor = UIColor.whiteColor()
            
            actionCell.selectionStyle = UITableViewCellSelectionStyle.None

            
            return actionCell
            
        }
        
        return cell
    }
 
    
    @IBAction func placeOrder(sender: AnyObject) {
        
        AnimationManager.sharedInstance.opaqueWindow(tabController)
        
        // Checkout Options
        if TabManager.sharedInstance.currentTab.checkoutMethod == "" {
            
            AlertManager.sharedInstance.checkoutOptions(self, controller: tabController, title: "Checkout Options", message: "Please select your desired checkout method below.")
            
            // If User already selected checkout option of stripe
        } else if TabManager.sharedInstance.currentTab.checkoutMethod == "stripe" {
            
            AlertManager.sharedInstance.checkout(self)
            
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get Screen Size
        let screenWidth = tabView.bounds.size.width
        let screenHeight = tabView.bounds.size.height
        
        
        // Enter Table Number Popover
        if segue.identifier == "enterTableNumber" {
            
            let vc = segue.destinationViewController as! TableNumberViewController
            
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight*0.405)
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            
            if controller != nil {
                
                controller!.sourceView = tabView
                controller!.sourceRect = CGRectMake(CGRectGetMidX(tabView.bounds) - 8, CGRectGetMidY(tabView.bounds) - 100, 0, 0)
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
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight*0.58)
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            
            if controller != nil {
                
                controller!.sourceView = tabView
                controller!.sourceRect = CGRectMake(CGRectGetMidX(tabView.bounds) - 8, CGRectGetMidY(tabView.bounds) - 100, 0, 0)
                controller?.delegate = self
            }
            
            // Protocol or GratuitySegue
            self.AddGratuityViewControllerRef = vc
            vc.delegate = self
            
            AlertManager.sharedInstance.delegate = self
            
        }
    }
    
    // PRESENTATION CONTROLLER DATA SOURCE
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        // Remove Opaque Window
        AnimationManager.sharedInstance.opaqueWindow(tabController)
        
        print("Popover closed.")
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
        
    }
}

// Extension for protocol in Table Number Popover
extension TabFloatingTableViewController: TableNumberViewDelegate, AddGratuityViewDelegate, AlertManagerDelegate {
    
    func gratuitySegue() {
        performSegueWithIdentifier("addGratuity", sender: self)
    }
    
    func removeOpaque() {
        AnimationManager.sharedInstance.opaqueWindow(tabController)
    }
    
    func passTabController() -> UIViewController {
        return tabController
    }
    
}
