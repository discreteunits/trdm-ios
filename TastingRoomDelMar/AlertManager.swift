//
//  AlertManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AlertManager: UIViewController {
    
    static let sharedInstance = AlertManager()
    
    // ---------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // ---------
    
    // Single Action Alert
    @available(iOS 8.0, *)
    func singleAlert(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
            print("User selected okay.")
            
        })
        
        // Add Actions To Alert
        alert.addAction(okAction)
        
        // Present Alert
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Checkout Options Alert
    func checkoutOptions(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let loginAction = UIAlertAction(title: "Closeout now ", style: .Default, handler: { (action) -> Void in
            TabManager.sharedInstance.currentTab.checkoutMethod = "stripe"
            
            // Continue Place Order
            self.stripeCheckout(view)
            
            print("Closeout Now Selected")
        })
        let createAccountAction = UIAlertAction(title: "Closeout later with your Server", style: .Default , handler: { (action) -> Void in
            TabManager.sharedInstance.currentTab.checkoutMethod = "server"
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
        alert.view.tintColor = UIColor.primaryGreenColor()
        
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

    // WhoopsCreditCard
    @available(iOS 8.0, *)
    func whoopsCreditCardAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
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
    
    // Add Table Number
    @available(iOS 8.0, *)
    func addTableNumberAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
            print("Ok Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //// Add Gratuity
    @available(iOS 8.0, *)
    func addGratuityAlert(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
            print("Ok Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //// GreatSuccessPreConfirm
    @available(iOS 8.0, *)
    func greatSuccessPreConfirm(title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Sounds Good", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Push Notifications Alert & Installation Assignment
    func pushNotificationsAlert() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            //  Swift 2.0
            if #available(iOS 8.0, *) {
                let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
                let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                UIApplication.sharedApplication().registerForRemoteNotifications()
            } else {
                let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
                UIApplication.sharedApplication().registerForRemoteNotificationTypes(types)
            }
            
            let installation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.addUniqueObject("customer", forKey: "channels")
            installation.saveInBackground()
            
        }
        
    }
    
    
    // ---------- Functions For Alert Actions
    
    // Conditional Check For Place Order
    func stripeCheckout(view: UIViewController) {
        
        // Whoops Logged In
        if TabManager.sharedInstance.currentTab.userId == "" {
            whoopsLoggedInAlert("Whoops", message: "Looks like you're not logged in or don't have an account. Login or create an account to place an order.")
        }
        
        // Whoops Credit Card
        if CardManager.sharedInstance.currentCustomer.card.brand == "" {
            whoopsCreditCardAlert("Whoops", message: "Looks like you don't have a credit card on file. Please add a card or checkout with your servers.")
        }
        
        // Enter Table Number
        if TabManager.sharedInstance.currentTab.table == "" {
            view.performSegueWithIdentifier("enterTableNumber", sender: view)
        }
        
        // Add Gratuity
        if (TabManager.sharedInstance.currentTab.gratuity.doubleValue != nil) {
            view.performSegueWithIdentifier("addGratuity", sender: view)
        }
        
    }
    
    // Go To Sign Up
    func goToLogIn() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "SignupStoryboard",bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("createAccount")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    // Go To Add Payment
    func goToAddPayment() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PaymentStoryboard",bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("Payment")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

}
