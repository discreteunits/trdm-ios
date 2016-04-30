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
<<<<<<< HEAD
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
=======
}

class AddGratuityViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var gratuityCollectionView: UICollectionView!
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
    
    var selectedGratuity = String()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    var delegate: AddGratuityViewDelegate?
<<<<<<< HEAD
    
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

=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd

// -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        

        
        let tabController = delegate?.passTabController()
        heightConstraint = tabController!.view.bounds.height
        let dynamicLocator = CGFloat(heightConstraint / 8)

=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd

        let popoverView = self.view
        popoverView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        
        // Screen Bounds
        let screenWidth = self.view.bounds.size.width - 20
//        let screenHeight = self.view.bounds.size.height
        
        // Create Add Gratuity Label
        let addGratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 30))
<<<<<<< HEAD
        addGratuityLabel.frame.origin.y = (dynamicLocator*0.15)
=======
        addGratuityLabel.frame.origin.y = 20
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        addGratuityLabel.frame.origin.x = 0
        addGratuityLabel.text = "Add Gratuity"
        addGratuityLabel.font = UIFont.headerFont(24)
        addGratuityLabel.textColor = UIColor.blackColor()
        addGratuityLabel.textAlignment = .Center
        // Create Text View
        let tableNumberTextView = UITextView(frame: CGRectMake(0, 0, screenWidth * 0.8, 80))
<<<<<<< HEAD
        tableNumberTextView.frame.origin.y = (dynamicLocator*0.4)
=======
        tableNumberTextView.frame.origin.y = 36
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        tableNumberTextView.frame.origin.x = screenWidth * 0.1
        tableNumberTextView.backgroundColor = UIColor.clearColor()
        tableNumberTextView.text = "We hope you enjoyed your experience at Tasting Room Del Mar! Come back soon!"
        tableNumberTextView.textColor = UIColor.blackColor()
<<<<<<< HEAD
        tableNumberTextView.font = UIFont.basicFont(13)
=======
        tableNumberTextView.font = UIFont.basicFont(14)
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        tableNumberTextView.textAlignment = .Center
        tableNumberTextView.userInteractionEnabled = false
        
        // Labels & Values
        let subTotalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
<<<<<<< HEAD
        subTotalLabel.frame.origin.y = dynamicLocator*1.4
=======
        subTotalLabel.frame.origin.y = 88
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        subTotalLabel.frame.origin.x = 8
        subTotalLabel.textAlignment = .Left
        subTotalLabel.text = "subtotal"
        subTotalLabel.font = UIFont.headerFont(18)

        let taxLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
<<<<<<< HEAD
        taxLabel.frame.origin.y = (dynamicLocator*1.7)
=======
        taxLabel.frame.origin.y = 108
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        taxLabel.frame.origin.x = 8
        taxLabel.textAlignment = .Left
        taxLabel.text = "tax"
        taxLabel.font = UIFont.headerFont(18)

        let gratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
<<<<<<< HEAD
        gratuityLabel.frame.origin.y = (dynamicLocator*2.0)
=======
        gratuityLabel.frame.origin.y = 128
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        gratuityLabel.frame.origin.x = 8
        gratuityLabel.textAlignment = .Left
        gratuityLabel.text = "Gratuity"
        gratuityLabel.font = UIFont.headerFont(18)

        let totalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
<<<<<<< HEAD
        totalLabel.frame.origin.y = (dynamicLocator*2.3)
=======
        totalLabel.frame.origin.y = 148
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        totalLabel.frame.origin.x = 8
        totalLabel.textAlignment = .Left
        totalLabel.text = "total"
        totalLabel.font = UIFont.headerFont(18)
        
<<<<<<< HEAD
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
=======
        let subTotalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        subTotalValueLabel.frame.origin.y = 88
        subTotalValueLabel.frame.origin.x = screenWidth * 0.65
        subTotalValueLabel.textAlignment = .Right
        subTotalValueLabel.text = String(TabManager.sharedInstance.currentTab.subtotal)
        subTotalValueLabel.font = UIFont.headerFont(18)

        let taxValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxValueLabel.frame.origin.y = 108
        taxValueLabel.frame.origin.x = screenWidth * 0.65
        taxValueLabel.textAlignment = .Right
        taxValueLabel.text = String(TabManager.sharedInstance.currentTab.totalTax)
        taxValueLabel.font = UIFont.headerFont(18)

        let gratuityValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityValueLabel.frame.origin.y = 128
        gratuityValueLabel.frame.origin.x = screenWidth * 0.65
        gratuityValueLabel.textAlignment = .Right
        gratuityValueLabel.text = String(TabManager.sharedInstance.currentTab.gratuity)
        gratuityValueLabel.font = UIFont.headerFont(18)
        
        let totalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalValueLabel.frame.origin.y = 148
        totalValueLabel.frame.origin.x = screenWidth * 0.65
        totalValueLabel.textAlignment = .Right
        totalValueLabel.text = String(TabManager.sharedInstance.currentTab.grandTotal)
        totalValueLabel.font = UIFont.headerFont(18)

        // Collection View
        let itemWidth = (screenWidth/5)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: itemWidth, height: 50)
        
        gratuityCollectionView = UICollectionView(frame: CGRectMake(0, 0, screenWidth, 66), collectionViewLayout: layout)
        gratuityCollectionView.frame.origin.y = 170
        gratuityCollectionView.frame.origin.x = 0
        gratuityCollectionView.backgroundColor = UIColor.clearColor()
        gratuityCollectionView.dataSource = self
        gratuityCollectionView.delegate = self
        gratuityCollectionView.registerClass(AddGratuityCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        
        // Create Cancel Button
        let buttonWidth = (screenWidth - 24) / 2
        
<<<<<<< HEAD
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, dynamicLocator*0.75))
        cancelButton.frame.origin.y = (dynamicLocator*3.75)
=======
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        cancelButton.frame.origin.y = 250
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        cancelButton.frame.origin.x = 8
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.scriptFont(18)
        cancelButton.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        cancelButton.layer.cornerRadius = 12.0
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(AddGratuityViewController.cancelPopover), forControlEvents: UIControlEvents.TouchUpInside)
        // Create Place Order Button
<<<<<<< HEAD
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, dynamicLocator*0.75))
        placeOrderButton.frame.origin.y = (dynamicLocator*3.75)
=======
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        placeOrderButton.frame.origin.y = 250
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
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
    
<<<<<<< HEAD
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
=======
        popoverView.addSubview(gratuityCollectionView)
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
        
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
<<<<<<< HEAD
=======
                    
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
                }
            
//            AlertManager.sharedInstance.greatSuccessPreConfirm(self, title: "Great Success!", message: "Your order has been received. We'll notify you once it's been confirmed.")
                
                
            // Gratuity was NOT set
            } else {
                
                AlertManager.sharedInstance.addGratuityAlert(self, title: "Whoops", message: "Please select a gratuity option")
                
            }
            
        // If User has NOT selected a gratuity option
        } else {
            
            AlertManager.sharedInstance.addGratuityAlert(self, title: "Whoops", message: "Please select a gratuity option")

        }
<<<<<<< HEAD
=======
        
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
    }
    
    func cancelPopover() {
        
        delegate?.removeOpaque()
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
<<<<<<< HEAD
=======

    
    // Collection Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = gratuityCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AddGratuityCollectionViewCell
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        
        // Cash Option
        if indexPath.row == 0 {

            cell.label.text = "Cash"
            cell.label.textColor = UIColor.blackColor()
            return cell
            
        // 15% Option
        } else if indexPath.row == 1 {

            cell.label.text = "15"
            return cell
            
        // 20% Option
        } else if indexPath.row == 2 {

            cell.label.text = "20"
            return cell
            
        // 25% Option
        } else if indexPath.row == 3 {

            cell.label.text = "25"
            return cell
            
        }
        
        
        return cell
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! AddGratuityCollectionViewCell
        
        selectedCell.label.backgroundColor = UIColor.blackColor()
        selectedCell.label.textColor = UIColor.whiteColor()
        
        // Cash
        if indexPath.row == 0 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            
            if printFlag {
                print("User chose a gratuity of: \(selectedGratuity).")
            }
            
        // 15%
        } else if indexPath.row == 1 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            
            if printFlag {
                print("User chose a gratuity of: \(selectedGratuity) precent.")
            }
            
        // 20%
        } else if indexPath.row == 2 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            
            if printFlag {
                print("User chose a gratuity of: \(selectedGratuity) precent.")
            }
            
        // 25%
        } else if indexPath.row == 3 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            
            if printFlag {
                print("User chose a gratuity of: \(selectedGratuity) precent.")
            }
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! AddGratuityCollectionViewCell
        
        selectedCell.label.backgroundColor = UIColor.clearColor()
        selectedCell.label.textColor = UIColor.blackColor()
        
    }
    
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
}

extension Double {
    var doubleValue: Double? {
        return Double(self)
    }
}
<<<<<<< HEAD


=======
>>>>>>> 048885ae56876e3021d217331ae28a8c125881bd
