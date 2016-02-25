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
        
        view.presentViewController(alert, animated: true, completion: nil)
    }

    //// WhoopsLoggedIn
    @available(iOS 8.0, *)
    func whoopsLoggedInAlert(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let loginAction = UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
            self.goToLogIn(view)
            print("Login Selected")
        })
        let createAccountAction = UIAlertAction(title: "Create Account", style: .Default , handler: { (action) -> Void in
            self.goToLogIn(view)
            print("Create Account Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(loginAction)
        alert.addAction(createAccountAction)
        alert.addAction(cancelAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }

    // WhoopsCreditCard
    @available(iOS 8.0, *)
    func whoopsCreditCardAlert(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let addCardAction = UIAlertAction(title: "Add Card", style: .Default, handler: { (action) -> Void in
       self.goToAddPayment(view)
            print("Add Card Selected")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(addCardAction)
        alert.addAction(cancelAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Add Table Number
    @available(iOS 8.0, *)
    func addTableNumberAlert(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
            print("Ok Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    //// Add Gratuity
    @available(iOS 8.0, *)
    func addGratuityAlert(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
            print("Ok Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    //// GreatSuccessPreConfirm
    @available(iOS 8.0, *)
    func greatSuccessPreConfirm(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let cancelAction = UIAlertAction(title: "Sounds Good", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Selected")
        })
        
        // Add Actions
        alert.addAction(cancelAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Added Successfully
    @available(iOS 8.0, *)
    func addedSuccess(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.primaryGreenColor()
        
        // Create Actions
        let successAction = UIAlertAction(title: "Sounds Good", style: .Default, handler: { (action) -> Void in
            self.confirm(view)
            print("Ok Selected")
        })
        
        // Add Actions
        alert.addAction(successAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Whoops Select Modifiers Please
    @available(iOS 8.0, *)
    func whoopsSelectModifiers(view: UIViewController, title: String, message: String) {
        
        // Create Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 9/255.0, green: 178/255.0, blue: 126/255.0, alpha: 1.0)
        
        // Create Actions
        let successAction = UIAlertAction(title: "Got It", style: .Default, handler: { (action) -> Void in
            print("Got It Selected")
        })
        
        // Add Actions
        alert.addAction(successAction)
        
        view.presentViewController(alert, animated: true, completion: nil)
        
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
            whoopsLoggedInAlert(view, title: "Whoops", message: "Looks like you're not logged in or don't have an account. Login or create an account to place an order.")
        }
        
        // Whoops Credit Card
        if CardManager.sharedInstance.currentCustomer.card.brand == "" {
            whoopsCreditCardAlert(view, title: "Whoops", message: "Looks like you don't have a credit card on file. Please add a card or checkout with your servers.")
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
    func goToLogIn(view: UIViewController) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "SignupStoryboard", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("createAccount")
        
        view.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    // Go To Add Payment
    func goToAddPayment(view: UIViewController) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PaymentStoryboard", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("Payment")
        
        view.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func confirm(view: UIViewController) {
        
        // Revert view controllers, views, and collections back to pre-popover state
        view.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
        
        let tierIVView = view.presentingViewController!.view
        if let viewWithTag = tierIVView!.viewWithTag(21) {
            
            viewWithTag.removeFromSuperview()
            // Items Indicator
            TabManager.sharedInstance.addItemsIndicator()
            
        }
        
    }

}
