//
//  EmailViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 5/16/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


class EmailViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let heightConstraint = self.view.bounds.height
        let dynamicFontSize = CGFloat(heightConstraint / 8)
        
        let popoverView = self.view
        popoverView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        
        // Screen Bounds
        let screenWidth = self.view.bounds.size.width - 20
        //        let screenHeight = self.view.bounds.size.height
        
        // Create Enter Table Number Label
        let enterEmailLabel = UILabel(frame: CGRectMake(0, 0, screenWidth, 20))
        enterEmailLabel.frame.origin.y = 25
        enterEmailLabel.frame.origin.x = 0
        enterEmailLabel.text = "Enter Your Email"
        enterEmailLabel.font = UIFont.basicFont(18)
        enterEmailLabel.textColor = UIColor.blackColor()
        enterEmailLabel.textAlignment = .Center
        
        // Create Text Field
        let emailTextField = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.8, dynamicFontSize + 16))
        emailTextField.frame.origin.y = 54
        emailTextField.frame.origin.x = screenWidth * 0.1
        emailTextField.placeholder = "youremail@email.com"
        emailTextField.font = UIFont.basicFont(dynamicFontSize/2)
        emailTextField.autocorrectionType = .No
        emailTextField.keyboardType = .NumberPad
        emailTextField.returnKeyType = .Done
        emailTextField.clearButtonMode = .Never
        emailTextField.contentVerticalAlignment = .Center
        emailTextField.textAlignment = .Center
        emailTextField.backgroundColor = UIColor.whiteColor()
        emailTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        
        // Create Cancel Button
        let buttonWidth = (screenWidth - 36) / 2
        
        let cancelButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, heightConstraint / 10))
        cancelButton.frame.origin.y = dynamicFontSize * 2.3
        cancelButton.frame.origin.x = 12
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.scriptFont(24)
        cancelButton.layer.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        cancelButton.layer.cornerRadius = 8.0
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(EmailViewController.cancelPopover), forControlEvents: UIControlEvents.TouchUpInside)
        // Create Place Order Button
        let placeOrderButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, heightConstraint / 10))
        placeOrderButton.frame.origin.y = dynamicFontSize * 2.3
        placeOrderButton.frame.origin.x = buttonWidth + 24
        placeOrderButton.setTitle("Save", forState: .Normal)
        placeOrderButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        placeOrderButton.titleLabel?.font = UIFont.scriptFont(24)
        placeOrderButton.layer.backgroundColor = UIColor.primaryGreenColor().CGColor
        placeOrderButton.layer.cornerRadius = 8.0
        placeOrderButton.clipsToBounds = true
        placeOrderButton.addTarget(self, action: #selector(EmailViewController.saveSelected), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add To View
        popoverView.addSubview(enterEmailLabel)
        popoverView.addSubview(emailTextField)
        popoverView.addSubview(cancelButton)
        popoverView.addSubview(placeOrderButton)
    
    
    }
    
    func cancelPopover() {
        
        // Clean Up
        TabManager.sharedInstance.currentTab.checkoutMethod = ""
        
//        delegate?.removeOpaque()
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func saveSelected() {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)

        performSegueWithIdentifier("enterTableNumber", sender: self)
        
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
