//
//  AddGratuityViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

@objc
protocol AddGratuityViewDelegate {
    func gratuitySegue()
    func removeOpaque()
    func passTabController() -> UIViewController
}

class GSlider : UISlider {
    
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = super.trackRectForBounds(bounds)
        newBounds.size.height = 24
        return newBounds
    }
}

class AddGratuityViewController: UIViewController {
    
    var selectedGratuity = String()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    var delegate: AddGratuityViewDelegate?
    
    var heightConstraint = CGFloat()

    // Price Formatter
    let formatter = PriceFormatManager.priceFormatManager
    
    var gratuityValue = String()
    var screenSizeSlider = CGRect()
    var screenWidthSlider = CGFloat()
    var screenHeightSlider = CGFloat()
    
    var gratuitySlider = GSlider()
    var gratuityValueLabel = UILabel()
    
    var subTotalValueLabel = UILabel()
    var taxValueLabel = UILabel()
    var totalValueLabel = UILabel()


// -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedGratuity = "18"
        
        let tabController = delegate?.passTabController()
        heightConstraint = tabController!.view.bounds.height
        let dynamicLocator = CGFloat(heightConstraint / 8)


        let popoverView = self.view
        popoverView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        
        // Screen Bounds
        let screenWidth = self.view.bounds.size.width - 20
//        let screenHeight = self.view.bounds.size.height
        
        // Create Add Gratuity Label
        let addGratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 30))
        addGratuityLabel.frame.origin.y = (dynamicLocator*0.15)
        addGratuityLabel.frame.origin.x = 0
        addGratuityLabel.text = "Add Gratuity"
        addGratuityLabel.font = UIFont.headerFont(24)
        addGratuityLabel.textColor = UIColor.blackColor()
        addGratuityLabel.textAlignment = .Center
        // Create Text View
        let tableNumberTextView = UITextView(frame: CGRectMake(0, 0, screenWidth * 0.8, 80))
        tableNumberTextView.frame.origin.y = (dynamicLocator*0.4)
        tableNumberTextView.frame.origin.x = screenWidth * 0.1
        tableNumberTextView.backgroundColor = UIColor.clearColor()
        tableNumberTextView.text = "We hope you enjoyed your experience at Tasting Room Del Mar! Come back soon!"
        tableNumberTextView.textColor = UIColor.blackColor()
        tableNumberTextView.font = UIFont.basicFont(13)
        tableNumberTextView.textAlignment = .Center
        tableNumberTextView.userInteractionEnabled = false
        
        // Labels & Values
        let subTotalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        subTotalLabel.frame.origin.y = dynamicLocator*1.4
        subTotalLabel.frame.origin.x = 8
        subTotalLabel.textAlignment = .Left
        subTotalLabel.text = "subtotal"
        subTotalLabel.font = UIFont.headerFont(18)

        let taxLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxLabel.frame.origin.y = (dynamicLocator*1.7)
        taxLabel.frame.origin.x = 8
        taxLabel.textAlignment = .Left
        taxLabel.text = "tax"
        taxLabel.font = UIFont.headerFont(18)

        let gratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityLabel.frame.origin.y = (dynamicLocator*2.0)
        gratuityLabel.frame.origin.x = 8
        gratuityLabel.textAlignment = .Left
        gratuityLabel.text = "Gratuity"
        gratuityLabel.font = UIFont.headerFont(18)

        let totalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalLabel.frame.origin.y = (dynamicLocator*2.3)
        totalLabel.frame.origin.x = 8
        totalLabel.textAlignment = .Left
        totalLabel.text = "total"
        totalLabel.font = UIFont.headerFont(18)
        
        subTotalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        subTotalValueLabel.frame.origin.y = dynamicLocator*1.4
        subTotalValueLabel.frame.origin.x = screenWidth * 0.65
        subTotalValueLabel.textAlignment = .Right
        let subTotalValue = TabManager.sharedInstance.currentTab.subtotal
        let convertedSubTotalValue = formatter.formatPrice(subTotalValue)
        subTotalValueLabel.text = String(convertedSubTotalValue)
        subTotalValueLabel.font = UIFont.headerFont(18)

        taxValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxValueLabel.frame.origin.y = (dynamicLocator*1.7)
        taxValueLabel.frame.origin.x = screenWidth * 0.65
        taxValueLabel.textAlignment = .Right
        let taxValue = TabManager.sharedInstance.currentTab.totalTax
        let convertedTaxValue = formatter.formatPrice(taxValue)
        taxValueLabel.text = String(convertedTaxValue)
        taxValueLabel.font = UIFont.headerFont(18)

        gratuityValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityValueLabel.frame.origin.y = (dynamicLocator*2.0)
        gratuityValueLabel.frame.origin.x = screenWidth * 0.65
        gratuityValueLabel.textAlignment = .Right
        let gratuityValue = TabManager.sharedInstance.currentTab.gratuity
        let convertedGratuityValue = formatter.formatPrice(gratuityValue)
        gratuityValueLabel.text = "18%"
        gratuityValueLabel.font = UIFont.headerFont(18)
        
        totalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalValueLabel.frame.origin.y = (dynamicLocator*2.3)
        totalValueLabel.frame.origin.x = screenWidth * 0.65
        totalValueLabel.textAlignment = .Right
        let totalValue = TabManager.sharedInstance.currentTab.grandTotal
        let convertedTotalValue = formatter.formatPrice(totalValue)
        totalValueLabel.text = String(convertedTotalValue)
        totalValueLabel.font = UIFont.headerFont(18)


        // Gratuity Slider
        screenSizeSlider = UIScreen.mainScreen().bounds
        screenWidthSlider = screenSizeSlider.width
        screenHeightSlider = screenSizeSlider.height
        
        gratuitySlider = GSlider(frame:CGRectMake(0, 0, screenWidth*0.98, 66))
        gratuitySlider.frame.origin.y = (dynamicLocator*2.65)
        gratuitySlider.frame.origin.x = screenWidth*0.01
        gratuitySlider.minimumValue = 0
        gratuitySlider.maximumValue = 100
        gratuitySlider.continuous = true
        gratuitySlider.tintColor = UIColor.primaryGreenColor()
        gratuitySlider.value = 18
        gratuitySlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        // Create Cancel Button
        let buttonWidth = (screenWidth - 24) / 2
        
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, dynamicLocator*0.75))
        cancelButton.frame.origin.y = (dynamicLocator*3.75)
        cancelButton.frame.origin.x = 8
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.scriptFont(18)
        cancelButton.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        cancelButton.layer.cornerRadius = 12.0
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(AddGratuityViewController.cancelPopover), forControlEvents: UIControlEvents.TouchUpInside)
        // Create Place Order Button
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, dynamicLocator*0.75))
        placeOrderButton.frame.origin.y = (dynamicLocator*3.75)
        placeOrderButton.frame.origin.x = buttonWidth + 16
        placeOrderButton.setTitle("Place Order", forState: .Normal)
        placeOrderButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        placeOrderButton.titleLabel?.font = UIFont.scriptFont(18)
        placeOrderButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        placeOrderButton.layer.cornerRadius = 12.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.addTarget(self, action: #selector(AddGratuityViewController.placeOrderWithGratuity), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add To View
        popoverView.addSubview(addGratuityLabel)
        popoverView.addSubview(tableNumberTextView)
        popoverView.addSubview(cancelButton)
        popoverView.addSubview(placeOrderButton)
        
        popoverView.addSubview(subTotalLabel)
        popoverView.addSubview(taxLabel)
        popoverView.addSubview(gratuityLabel)
        popoverView.addSubview(totalLabel)
        
        popoverView.addSubview(subTotalValueLabel)
        popoverView.addSubview(taxValueLabel)
        popoverView.addSubview(gratuityValueLabel)
        popoverView.addSubview(totalValueLabel)
    
        popoverView.addSubview(gratuitySlider)

    }
    
    func sliderValueDidChange(sender:UISlider!) {
        
        let output = Int(sender.value)
        gratuitySlider.value = Float(output)
        
        print("Gratuity Value: \(sender.value)")
        gratuityValueLabel.text = String(output) + "%"
        
        selectedGratuity = String(output)
        
        TabManager.sharedInstance.totalCellCalculator()
        TabManager.sharedInstance.gratuityCalculator(String(output))
        
        let subTotalValue = TabManager.sharedInstance.currentTab.subtotal
        let convertedSubTotalValue = formatter.formatPrice(subTotalValue)
        subTotalValueLabel.text = String(convertedSubTotalValue)
     
        let taxValue = TabManager.sharedInstance.currentTab.totalTax
        let convertedTaxValue = formatter.formatPrice(taxValue)
        taxValueLabel.text = String(convertedTaxValue)
        
        let totalValue = TabManager.sharedInstance.currentTab.grandTotal
        let convertedTotalValue = formatter.formatPrice(totalValue)
        totalValueLabel.text = String(convertedTotalValue)
        
    }
    
    func placeOrderWithGratuity() {
        
        // If user has selected a gratuity option
        if selectedGratuity != "" {
            
            // Calculate Gratuity Property
            TabManager.sharedInstance.gratuityCalculator(selectedGratuity)
            
            
            // Set Gratuity Percent For CloudCode Function
            let gratuityPercent = Double(selectedGratuity)! / 100
            TabManager.sharedInstance.currentTab.gratuityPercent = gratuityPercent
            
            
            // Confirm if gratuity was set -- Not successfully checking doubleValue
            if (TabManager.sharedInstance.currentTab.gratuity.doubleValue != nil) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    let result = TabManager.sharedInstance.placeOrder(self, tab: TabManager.sharedInstance.currentTab)
                    
                    if printFlag {
                        print("Place Order, CloudCode Function Returned: \(result)")
                    }
                }
            
//            AlertManager.sharedInstance.greatSuccessPreConfirm(self, title: "Great Success!", message: "Your order has been received. We'll notify you once it's been confirmed.")
                
                
            // Gratuity was NOT set
            } else {
                
                AlertManager.sharedInstance.addGratuityAlert(self, title: "Whoops", message: "Please select a gratuity option.")
                
            }
            
        // If User has NOT selected a gratuity option
        } else {
            
            AlertManager.sharedInstance.addGratuityAlert(self, title: "Whoops", message: "Please select a gratuity option")

        }
    }
    
    func cancelPopover() {
        
        // Clean Up
        TabManager.sharedInstance.currentTab.table = ""
        TabManager.sharedInstance.currentTab.checkoutMethod = ""
        
        delegate?.removeOpaque()
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Double {
    var doubleValue: Double? {
        return Double(self)
    }
}


