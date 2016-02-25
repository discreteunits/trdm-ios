//
//  TableNumberViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

@objc
protocol TableNumberViewDelegate {
    func gratuitySegue()
}

class TableNumberViewController: UIViewController, UITextFieldDelegate {

    var tableNumberTextField: UITextField!
    
    var tab = TabManager.sharedInstance.currentTab
    
    var delegate: TableNumberViewDelegate?
    var TabTableViewControllerRef: TabTableViewController?
    
// -------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        let popoverView = self.view
            popoverView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        // Screen Bounds
        let screenWidth = self.view.bounds.size.width - 20
        let screenHeight = self.view.bounds.size.height
        // Create Enter Table Number Label
        let enterTableNumberLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
        enterTableNumberLabel.frame.origin.y = 25
        enterTableNumberLabel.frame.origin.x = 0
        enterTableNumberLabel.text = "enter table number"
        enterTableNumberLabel.font = UIFont.basicFont(18)
        enterTableNumberLabel.textColor = UIColor.blackColor()
        enterTableNumberLabel.textAlignment = .Center
        // Create Text Field
        tableNumberTextField = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.3, 100))
        tableNumberTextField.frame.origin.y = 54
        tableNumberTextField.frame.origin.x = screenWidth * 0.36
        tableNumberTextField.placeholder = "23"
        tableNumberTextField.font = UIFont.basicFont(72)
        tableNumberTextField.autocorrectionType = .No
        tableNumberTextField.keyboardType = .NumberPad
        tableNumberTextField.returnKeyType = .Done
        tableNumberTextField.clearButtonMode = .Never
        tableNumberTextField.contentVerticalAlignment = .Center
        tableNumberTextField.textAlignment = .Center
        tableNumberTextField.backgroundColor = UIColor.whiteColor()
        tableNumberTextField.becomeFirstResponder()
        // Create Cancel Button
        let buttonWidth = (screenWidth - 24) / 2
        
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        cancelButton.frame.origin.y = 160
        cancelButton.frame.origin.x = 8
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.scriptFont(18)
        cancelButton.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        cancelButton.layer.cornerRadius = 12.0
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: "cancelPopover", forControlEvents: UIControlEvents.TouchUpInside)
        // Create Place Order Button
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        placeOrderButton.frame.origin.y = 160
        placeOrderButton.frame.origin.x = buttonWidth + 16
        placeOrderButton.setTitle("Place Order", forState: .Normal)
        placeOrderButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        placeOrderButton.titleLabel?.font = UIFont.scriptFont(18)
        placeOrderButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        placeOrderButton.layer.cornerRadius = 12.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.addTarget(self, action: "placeOrderSelected", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add To View
        popoverView.addSubview(enterTableNumberLabel)
        popoverView.addSubview(tableNumberTextField)
        popoverView.addSubview(cancelButton)
        popoverView.addSubview(placeOrderButton)
    
    }
    
    
    func cancelPopover() {
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func placeOrderSelected() {
        
        // Check if text field is empty
        if tableNumberTextField.text! != "" {
            
            // Set Table Number
                TabManager.sharedInstance.currentTab.table = String(self.tableNumberTextField.text!)
                print("User entered table number: \(TabManager.sharedInstance.currentTab.table)")
        
            // If table number was set
            if TabManager.sharedInstance.currentTab.table != "" {
                
                // If gratuity is still empty, go to addGratuity
                if (TabManager.sharedInstance.currentTab.gratuity.doubleValue != nil) {
                    
                    self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.gratuitySegue()
                    }
                
                // If Gratuity is NOT empty, continue placing order
                } else {
                    
                    let result = TabManager.sharedInstance.placeOrder(TabManager.sharedInstance.currentTab)
                    print("Continuing to place order from TableNumberViewController: \(result)")
                    
                    self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
            // If table number was NOT set
            } else {
                
                AlertManager.sharedInstance.addTableNumberAlert("Whoops", message: "Please enter your table number.")
                
            }
        
        // If text field was empty
        } else {
            
            AlertManager.sharedInstance.addTableNumberAlert("Whoops", message: "Please enter your table number.")
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
