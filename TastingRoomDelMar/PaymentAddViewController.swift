//
//  PaymentAddViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Stripe

class PaymentAddViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    let currentCustomer = CardManager.sharedInstance.currentCustomer
    
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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
// ----------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "Add Payment"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back:")
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "BebasNeueRegular", size: 24)!], forState: UIControlState.Normal)
            
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
            print("Field Validation Alert Fired")
        })
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // ACTIVITY START FUNCTION
    func activityStart() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
    }
    
    // ACTIVITY STOP FUNCTION
    func activityStop() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }


    
    // Check if text fields have been edited
    @IBAction func cardNumberDidChange(sender: AnyObject) {
        print("Card Number Added")
    }
    @IBAction func expMonthDidChange(sender: AnyObject) {
        print("Expiration Month Added")
    }
    @IBAction func expYearDidChange(sender: AnyObject) {
        print("Expiration Year Added")
    }
    @IBAction func cvcDidChange(sender: AnyObject) {
        print("CVC Added")
    }
    
    // Finish flagging to refactor
    func textFieldDidchange(textfield: UITextField) {
        print("\(textfield) did change.")
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
    
    func performStripeOperation() {
        STPAPIClient.sharedClient().createTokenWithCard(stripeCard) { ( token, error) -> Void in
        
            self.activityStart()
            
            if let error = error {
                
                // Failure
                self.activityStop()
                print("\(error)")
                self.displayAlert("Failed", message: "Please try again later.")
                
            } else {
                
                // Success 
                self.activityStop()
                print("Token Created: 4r\(token)")
                
                
                // Set Cloud Code Token
                
                
                // Dismiss View
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
        }
        
    }

    // Validate Card Info, Get Token
    @IBAction func saveCard(sender: AnyObject) {

        // Validation
        if CardNumberTextField.text?.isEmpty == false &&
            ExpMonthTextField.text?.isEmpty == false &&
            ExpYearTextField.text?.isEmpty == false &&
            CVCTextField.text?.isEmpty == false {
                
        // Package typed in data to object
            stripeCard.number = CardNumberTextField.text!
            stripeCard.expMonth = UInt(ExpMonthTextField.text!)!
            stripeCard.expYear = UInt(ExpYearTextField.text!)!
            stripeCard.cvc = CVCTextField.text!
            print("StripeCard Created: \(stripeCard)")
                
        } else {
            displayAlert("Required", message: "All fields are required.")
        }
        
        performStripeOperation()
        
        
//        if validateCardInfo() {
//            performStripeOperation()
//        }
        
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