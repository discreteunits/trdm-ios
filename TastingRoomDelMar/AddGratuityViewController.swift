//
//  AddGratuityViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class AddGratuityViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var gratuityCollectionView: UICollectionView!
    
    var selectedGratuity = String()
    
    var tab = TabManager.sharedInstance.currentTab
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

// -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        let popoverView = self.view
        popoverView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        // Screen Bounds
        let screenWidth = self.view.bounds.size.width - 20
        let screenHeight = self.view.bounds.size.height
        // Create Add Gratuity Label
        let addGratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 30))
        addGratuityLabel.frame.origin.y = 20
        addGratuityLabel.frame.origin.x = 0
        addGratuityLabel.text = "Add Gratuity"
        addGratuityLabel.font = UIFont(name: "BebasNeueRegular", size: 24)
        addGratuityLabel.textColor = UIColor.blackColor()
        addGratuityLabel.textAlignment = .Center
        // Create Text View
        let tableNumberTextView = UITextView(frame: CGRectMake(0, 0, screenWidth * 0.8, 80))
        tableNumberTextView.frame.origin.y = 36
        tableNumberTextView.frame.origin.x = screenWidth * 0.1
        tableNumberTextView.backgroundColor = UIColor.clearColor()
        tableNumberTextView.text = "We hope you enjoyed your experience at Tasting Room Del Mar! Come back soon!"
        tableNumberTextView.textColor = UIColor.blackColor()
        tableNumberTextView.font = UIFont(name: "OpenSans", size: 14)
        tableNumberTextView.textAlignment = .Center
        tableNumberTextView.userInteractionEnabled = false
        
        // Labels & Values
        let subTotalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        subTotalLabel.frame.origin.y = 88
        subTotalLabel.frame.origin.x = 8
        subTotalLabel.textAlignment = .Left
        subTotalLabel.text = "subtotal"
        subTotalLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        let taxLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxLabel.frame.origin.y = 108
        taxLabel.frame.origin.x = 8
        taxLabel.textAlignment = .Left
        taxLabel.text = "tax"
        taxLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        let gratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityLabel.frame.origin.y = 128
        gratuityLabel.frame.origin.x = 8
        gratuityLabel.textAlignment = .Left
        gratuityLabel.text = "Gratuity"
        gratuityLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        let totalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalLabel.frame.origin.y = 148
        totalLabel.frame.origin.x = 8
        totalLabel.textAlignment = .Left
        totalLabel.text = "total"
        totalLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        
        let subTotalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        subTotalValueLabel.frame.origin.y = 88
        subTotalValueLabel.frame.origin.x = screenWidth * 0.65
        subTotalValueLabel.textAlignment = .Right
        subTotalValueLabel.text = String(TabManager.sharedInstance.currentTab.subtotal)
        subTotalValueLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        let taxValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxValueLabel.frame.origin.y = 108
        taxValueLabel.frame.origin.x = screenWidth * 0.65
        taxValueLabel.textAlignment = .Right
        taxValueLabel.text = String(TabManager.sharedInstance.currentTab.totalTax)
        taxValueLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        let gratuityValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityValueLabel.frame.origin.y = 128
        gratuityValueLabel.frame.origin.x = screenWidth * 0.65
        gratuityValueLabel.textAlignment = .Right
        gratuityValueLabel.text = String(TabManager.sharedInstance.currentTab.gratuity)
        gratuityValueLabel.font = UIFont(name: "BebasNeueRegular", size: 18)

        let totalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalValueLabel.frame.origin.y = 148
        totalValueLabel.frame.origin.x = screenWidth * 0.65
        totalValueLabel.textAlignment = .Right
        totalValueLabel.text = String(TabManager.sharedInstance.currentTab.grandTotal)
        totalValueLabel.font = UIFont(name: "BebasNeueRegular", size: 18)


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
        
        // Create Cancel Button
        let buttonWidth = (screenWidth - 24) / 2
        
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        cancelButton.frame.origin.y = 250
        cancelButton.frame.origin.x = 8
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        cancelButton.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        cancelButton.layer.cornerRadius = 12.0
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: "cancelPopover", forControlEvents: UIControlEvents.TouchUpInside)
        // Create Place Order Button
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        placeOrderButton.frame.origin.y = 250
        placeOrderButton.frame.origin.x = buttonWidth + 16
        placeOrderButton.setTitle("Place Order", forState: .Normal)
        placeOrderButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        placeOrderButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
        placeOrderButton.layer.cornerRadius = 12.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.addTarget(self, action: "placeOrderWithGratuity", forControlEvents: UIControlEvents.TouchUpInside)
        
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
    
        popoverView.addSubview(gratuityCollectionView)
        
    
    }
    
    func placeOrderWithGratuity() {
        
        
        // If user has selected a gratuity option
        if selectedGratuity != "" {
            
            // Calculate Gratuity Property
            TabManager.sharedInstance.gratuityCalculator(selectedGratuity)
            
            // Confirm if gratuity was set -- Not successfully checking doubleValue
            if (TabManager.sharedInstance.currentTab.gratuity.doubleValue != nil) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    let result = TabManager.sharedInstance.placeOrder(TabManager.sharedInstance.currentTab)
                    print("Place Order, CloudCode Function Returned: \(result)")
                }
                
                greatSuccessPreConfirm("Great Success!", message: "Your order has been received. We'll notify you once it's been confirmed.")
                
            // Gratuity was NOT set
            } else {
                
                addGratuityAlert("Whoops", message: "Please selected a gratuity option.")
                
            }
            
        // If User has NOT selected a gratuity option
        } else {
            
            addGratuityAlert("Whoops", message: "Please selected a gratuity option.")

        }
        
    }
    
    func cancelPopover() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // ----------------------
    // Collection View Data Source
    // ----------------------

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
            print("User chose a gratuity of: \(selectedGratuity).")

        // 15%
        } else if indexPath.row == 1 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            print("User chose a gratuity of: \(selectedGratuity) precent.")

            // 20%
        } else if indexPath.row == 2 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            print("User chose a gratuity of: \(selectedGratuity) precent.")
        
            // 25%
        } else if indexPath.row == 3 {
            
            // Set
            selectedGratuity = selectedCell.label.text!
            print("User chose a gratuity of: \(selectedGratuity) precent.")
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! AddGratuityCollectionViewCell
        
        selectedCell.label.backgroundColor = UIColor.clearColor()
        selectedCell.label.textColor = UIColor.blackColor()
        
    }
    
    
    
    //// Add Gratuity
    @available(iOS 8.0, *)
    func addGratuityAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
            print("Ok Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // ACTIVITY START FUNCTION
    func activityStart() {
        activityIndicator.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        activityIndicator.layer.zPosition = 9999999
//        var currentWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
//        currentWindow.addSubview(activityIndicator)
        
        self.view.addSubview(activityIndicator)
    }
    
    // ACTIVITY STOP FUNCTION
    func activityStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    //// GreatSuccessPreConfirm
    @available(iOS 8.0, *)
    func greatSuccessPreConfirm(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Sounds Good", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension Double {
    var doubleValue: Double? {
        return Double(self)
    }
}
