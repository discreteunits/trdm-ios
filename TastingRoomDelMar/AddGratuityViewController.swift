//
//  AddGratuityViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class AddGratuityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let popoverView = self.view
        popoverView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        // Screen Bounds
        let screenWidth = self.view.bounds.size.width - 20
        let screenHeight = self.view.bounds.size.height
        // Create Add Gratuity Label
        let addGratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
        addGratuityLabel.frame.origin.y = 20
        addGratuityLabel.frame.origin.x = 0
        addGratuityLabel.text = "Add Gratuity"
        addGratuityLabel.font = UIFont(name: "OpenSans", size: 18)
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
        let taxLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxLabel.frame.origin.y = 108
        taxLabel.frame.origin.x = 8
        taxLabel.textAlignment = .Left
        taxLabel.text = "tax"
        let gratuityLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityLabel.frame.origin.y = 128
        gratuityLabel.frame.origin.x = 8
        gratuityLabel.textAlignment = .Left
        gratuityLabel.text = "Gratuity"
        let totalLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalLabel.frame.origin.y = 148
        totalLabel.frame.origin.x = 8
        totalLabel.textAlignment = .Left
        totalLabel.text = "total"

        
        let subTotalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        subTotalValueLabel.frame.origin.y = 88
        subTotalValueLabel.frame.origin.x = screenWidth * 0.65
        subTotalValueLabel.textAlignment = .Right
        subTotalValueLabel.text = "38.00"
        let taxValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        taxValueLabel.frame.origin.y = 108
        taxValueLabel.frame.origin.x = screenWidth * 0.65
        taxValueLabel.textAlignment = .Right
        taxValueLabel.text = "3.04"
        let gratuityValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        gratuityValueLabel.frame.origin.y = 128
        gratuityValueLabel.frame.origin.x = screenWidth * 0.65
        gratuityValueLabel.textAlignment = .Right
        gratuityValueLabel.text = "9.50"
        let totalValueLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.3, 20))
        totalValueLabel.frame.origin.y = 148
        totalValueLabel.frame.origin.x = screenWidth * 0.65
        totalValueLabel.textAlignment = .Right
        totalValueLabel.text = "50.54"

        
        
        
        // Collection View
        
        
        
        
        
        // Create Cancel Button
        let buttonWidth = (screenWidth - 24) / 2
        
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        cancelButton.frame.origin.y = 280
        cancelButton.frame.origin.x = 8
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        cancelButton.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
        cancelButton.layer.cornerRadius = 12.0
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: "cancelPopover:", forControlEvents: UIControlEvents.TouchUpInside)
        // Create Place Order Button
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        placeOrderButton.frame.origin.y = 280
        placeOrderButton.frame.origin.x = buttonWidth + 16
        placeOrderButton.setTitle("Place Order", forState: .Normal)
        placeOrderButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        placeOrderButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
        placeOrderButton.layer.cornerRadius = 12.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.addTarget(self, action: "placeOrder:", forControlEvents: UIControlEvents.TouchUpInside)
        
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

}
