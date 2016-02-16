//
//  TableNumberViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TableNumberViewController: UIViewController {

    
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
        enterTableNumberLabel.font = UIFont(name: "OpenSans", size: 18)
        enterTableNumberLabel.textColor = UIColor.blackColor()
        enterTableNumberLabel.textAlignment = .Center
        // Create Text Field
        let tableNumberTextField = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.3, 120))
        tableNumberTextField.frame.origin.y = 54
        tableNumberTextField.frame.origin.x = screenWidth * 0.38
        tableNumberTextField.placeholder = "23"
        tableNumberTextField.font = UIFont(name: "OpenSans", size: 72)
        tableNumberTextField.autocorrectionType = .No
        tableNumberTextField.keyboardType = .NumberPad
        tableNumberTextField.returnKeyType = .Done
        tableNumberTextField.clearButtonMode = .WhileEditing
        tableNumberTextField.contentVerticalAlignment = .Center
        // Create Cancel Button
        let buttonWidth = (screenWidth - 24) / 2
        
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 60))
        cancelButton.frame.origin.y = 160
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
        placeOrderButton.frame.origin.y = 160
        placeOrderButton.frame.origin.x = buttonWidth + 16
        placeOrderButton.setTitle("Place Order", forState: .Normal)
        placeOrderButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        placeOrderButton.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 18)
        placeOrderButton.layer.backgroundColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0).CGColor
        placeOrderButton.layer.cornerRadius = 12.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.addTarget(self, action: "placeOrder:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add To View
        popoverView.addSubview(enterTableNumberLabel)
        popoverView.addSubview(tableNumberTextField)
        popoverView.addSubview(cancelButton)
        popoverView.addSubview(placeOrderButton)
    
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// -------------------
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
