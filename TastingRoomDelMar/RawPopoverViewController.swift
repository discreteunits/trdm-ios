//
//  PopOverViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/15/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class RawPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var popover: UIPopoverController?
    
    @IBOutlet weak var checkoutOptionsButton: UIButton!
    
    @IBOutlet weak var enterTableNumberButton: UIButton!
    
    @IBOutlet weak var addGratuityButton: UIButton!
    
    @IBOutlet weak var whoopsLoggedInButton: UIButton!
    
    @IBOutlet weak var whoopsCreditCardButton: UIButton!
    
    @IBOutlet weak var greatSuccessPreConfirmedButton: UIButton!
    
    @IBOutlet weak var greatSuccessConfirmedButton: UIButton!
    
    @IBOutlet weak var greatSuccessPrintedButton: UIButton!
    
    @IBOutlet weak var greatSuccessAddedCardButton: UIButton!
    
    
    // ----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -------------------------
    
//    @IBAction func popover(sender: AnyObject) {
//        self.performSegueWithIdentifier("showPopover", sender: self)
//    }
//    
    
    // ALERT
    @IBAction func checkoutOptions(sender: AnyObject) {
        checkoutOptions("Checkout Options", message: "Please select your desired checkout method below.")
    }
    
    
    
    
    
    // POPOVER
    @IBAction func enterTableNumber(sender: AnyObject) {
        performSegueWithIdentifier("enterTableNumber", sender: self)
    }

    
    // POPOVER
    @IBAction func addGratuity(sender: AnyObject) {
        performSegueWithIdentifier("addGratuity", sender: self)
    }

    
    
    
    
    
    
    // ALERT
    @IBAction func whoopsLoggedIn(sender: AnyObject) {
        whoopsLoggedInAlert("Whoops", message: "Looks like you're not logged in or don't have an account. Login or create an account to place an order.")
    }
    
    // ALERT
    @IBAction func whoopsCreditCard(sender: AnyObject) {
        whoopsCreditCardAlert("Whoops", message: "Looks like you don't have a credit card on file. Please add a card or checkout with your servers.")
    }
    
    // ALERT
    @IBAction func greatSuccessPreConfirmed(sender: AnyObject) {
        greatSuccessPreConfirm("Great Success!", message: "Your order has been received. We'll notify you once it's been confirmed.")
    }
    
    // ALERT
    @IBAction func greatSuccessConfirmed(sender: AnyObject) {
        greatSuccessConfirm("Great Success!", message: "Your order has been placed and will be brought out to Kaiser at table 23 as soon as it's ready!")
    }
    
    // ALERT
    @IBAction func greatSuccessPrinted(sender: AnyObject) {
        greatSuccessPrinted("Great Success!", message: "Your order for Kaiser at table 23 has been placed and your card has been charged for $118.56.")
    }
    
    // ALERT
    @IBAction func greatSuccessAddedCard(sender: AnyObject) {
        greatSuccessAddedCard("Great Success!", message: "Your card has been added successfully. You're ready to start placing orders!")
    }
    
    
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get Screen Size 
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        
        // Enter Table Number Popover
        if segue.identifier == "enterTableNumber" {
            
            let vc = segue.destinationViewController as! TableNumberViewController
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight*0.35)
            
            // Data To Be Passed
            
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller?.delegate = self
            }
            
        }
        
        // Add Gratuity Popover
        if segue.identifier == "addGratuity" {
            let vc = segue.destinationViewController as! AddGratuityViewController
            // Size Popover Window
            vc.preferredContentSize = CGSizeMake(screenWidth, screenHeight * 0.5)
            
            // Data To Be Passed
            
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller?.delegate = self
            }
            
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    // ------------------------------
    
    
    //// CheckoutOptions
    @available(iOS 8.0, *)
    func checkoutOptions(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let loginAction = UIAlertAction(title: "Closeout now ", style: .Default, handler: { (action) -> Void in
            self.goToLogIn()
            print("Closeout Now Selected")
        })
        let createAccountAction = UIAlertAction(title: "Closeout later with your Server", style: .Default , handler: { (action) -> Void in
            self.goToLogIn()
            print("Closeout Later Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(loginAction)
        alert.addAction(createAccountAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //// WhoopsLoggedIn
    @available(iOS 8.0, *)
    func whoopsLoggedInAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let loginAction = UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
            self.goToLogIn()
            print("Login Selected")
        })
        let createAccountAction = UIAlertAction(title: "Create Account", style: .Default , handler: { (action) -> Void in
            self.goToLogIn()
            print("Create Account Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(loginAction)
        alert.addAction(createAccountAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //// WhoopsCreditCard
    @available(iOS 8.0, *)
    func whoopsCreditCardAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let addCardAction = UIAlertAction(title: "Add Card", style: .Default, handler: { (action) -> Void in
            self.goToAddPayment()
            print("Add Card Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(addCardAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    
    //// GreatSuccessConfirm
    @available(iOS 8.0, *)
    func greatSuccessConfirm(title: String, message: String) {
        
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
 
    
    //// GreatSuccessPrinted
    @available(iOS 8.0, *)
    func greatSuccessPrinted(title: String, message: String) {
        
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
    
    
    //// GreatSuccessAddedCard
    @available(iOS 8.0, *)
    func greatSuccessAddedCard(title: String, message: String) {
        
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
    
    
    
    // -------------------------------------
    
    // 1. WhoopsLoggedIn, 2.
    func goToLogIn() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("createAccount")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func goToAddPayment() {
        
    }
    
    
    
    
    
    
    
    
    

}
