//
//  PaymentViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse



class PaymentViewController: UIViewController {

    var nav: UINavigationBar?

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "Payment"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
        }
        
        getCards()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func menu(sender: AnyObject) {
        
        // From Flyout
        if TabManager.sharedInstance.paymentToTab {
            self.dismissViewControllerAnimated(true, completion: nil)
            TabManager.sharedInstance.addItemsIndicator()
        // From Tab Popover
        } else {
            TabManager.sharedInstance.paymentToTab = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        

        
    }
    
    // Get Card CLOUDCODE FUNCTION CALL FETCH
    func getCards() {
        
        dispatch_async(dispatch_get_main_queue()){
            
            // Get User Card via User Object ID
            let card = CardManager.sharedInstance.fetchCards(TabManager.sharedInstance.currentTab.userId)
            CardManager.sharedInstance.currentCustomer.orderId.append(String(card))
            
        }
    }

}
