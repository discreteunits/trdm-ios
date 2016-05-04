//
//  PaymentAddViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Stripe
import Parse
import ParseUI

class PaymentAddViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    var currentCustomer = CardManager.sharedInstance.currentCustomer
    
    var stripeCard = STPCardParams()

    var nav: UINavigationBar?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var CardNumberTextField: UITextField!
    @IBOutlet weak var ExpMonthTextField: UITextField!
    @IBOutlet weak var ExpYearTextField: UITextField!
    @IBOutlet weak var CVCTextField: UITextField!
    
    @IBOutlet weak var CardNumberLabel: UILabel!
    @IBOutlet weak var ExpLabel: UILabel!
    @IBOutlet weak var CVCLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
// ----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "Add Payment"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(PaymentAddViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont.headerFont(24)], forState: UIControlState.Normal)
            
        }
        
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ALERT FUNCTION
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
            if printFlag {
                print("Field Validation Alert Fired")
            }
        
        })
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Check if text fields have been edited
    @IBAction func cardNumberDidChange(sender: AnyObject) {
        
        if printFlag {
            print("Card Number Added")
        }
        
    }
    @IBAction func expMonthDidChange(sender: AnyObject) {
        
        if printFlag {
            print("Expiration Month Added")
        }
        
    }
    @IBAction func expYearDidChange(sender: AnyObject) {
        
        if printFlag {
            print("Expiration Year Added")
        }
        
    }
    @IBAction func cvcDidChange(sender: AnyObject) {
        
        if printFlag {
            print("CVC Added")
        }
        
    }
    
    // Finish flagging to refactor
    func textFieldDidchange(textfield: UITextField) {
        
        if printFlag {
            print("\(textfield) did change.")
        }
        
    }
   
    
/*
    // Stripe Server Validation
    func validateCardInfo() -> Bool {

        // requires text field for card type, ie: visa, mastercard
        STPCardValidator.validationStateForNumber(CardNumberTextField.text!, validatingCardBrand: true)
        STPCardValidator.validationStateForExpirationMonth(ExpMonthTextField.text!)
        STPCardValidator.validationStateForExpirationYear(ExpYearTextField.text!, inMonth: ExpMonthTextField.text!)
        STPCardValidator.validationStateForCVC(CVCTextField.text!, cardBrand: STPCardBrand.Visa)

       return true
    }
*/
    
    
    // Ask For Token
    func performStripeOperation() {
        STPAPIClient.sharedClient().createTokenWithCard(stripeCard) { ( token, error) -> Void in
        
            // Failure
            if let error = error {
                
                if printFlag {
                    print("\(error)")
                }
                
                self.displayAlert("Whoops!", message: "Please try again later.")
                
            // Success
            } else {
                
                
                if printFlag {
                    print("Token Created: \(token!.tokenId)")
                }
                
                
//                // Alert
//                AlertManager.sharedInstance.greatSuccessAddedCard(self, title: "Great Success!", message: "Card successfully added.")

                
                // Set User Card CLOUDCODE
                let user = PFUser.currentUser()?.objectId
                var confirmedUserCard: AnyObject!

                confirmedUserCard = CardManager.sharedInstance.setCard(user!, token: token!.tokenId, view: self)
                
                if printFlag {
                    print("Confirmed User Card Created: \(confirmedUserCard)")
                    print("----------------")
                }

                
                AlertManager.sharedInstance.greatSuccessAddedCard(self, title: "Great Success!", message: "Your card has been added to your account.")
                
                
            }
        }
    }
    
    // Create Customer Trigger
    @IBAction func saveCard(sender: AnyObject) {

        // Validation
        if CardNumberTextField.text?.isEmpty == false &&
            ExpMonthTextField.text?.isEmpty == false &&
            ExpYearTextField.text?.isEmpty == false &&
            CVCTextField.text?.isEmpty == false {
                
        // Package typed in data to object
            stripeCard.number = String(CardNumberTextField.text!)
            stripeCard.expMonth = UInt(ExpMonthTextField.text!)!
            stripeCard.expYear = UInt(ExpYearTextField.text!)!
            stripeCard.cvc = String(CVCTextField.text!)
                
            if printFlag {
                print("StripeCard Created: \(stripeCard)")
            }
                
        } else {
            displayAlert("Required", message: "All fields are required.")
        }
        
        // Set Card
        performStripeOperation()

//        if validateCardInfo() {
//            performStripeOperation()
//        }
        
    }
   
}
