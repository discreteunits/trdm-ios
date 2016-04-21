//
//  TabViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import ParseCrashReporting

class TabViewController: UIViewController {

    var nav: UINavigationBar?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!

    var TabTableViewControllerRef: TabTableViewController?
    var TabFloatingTableViewControllerRef: TabFloatingTableViewController?
    
    var tab = TabManager.sharedInstance.currentTab
    var orders = CardManager.sharedInstance.currentCustomer
    

// ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if printFlag {
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            print("TAB: \(tab)")
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@")

            print("-----------------------------")
            print("Lines: \(tab.lines.count)")
            print("Orders: \(orders.orderId.count)")
            print("-----------------------------")
        }
        
        defaultScreen()

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "My Tab"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToMenu() {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
        // Add Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
    }
    
    @IBAction func menu(sender: AnyObject) {
        
//        if let parentVC = self.parentViewController {
//            if let parentVC = parentVC as? PopoverViewController {
//                parentVC.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        
        // Add Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "tabTableEmbeded" {
            
            if let TabTableViewController = segue.destinationViewController as? TabTableViewController {
                
                self.TabTableViewControllerRef = TabTableViewController
                
            } 
        }
        
        if segue.identifier == "tabFloatingEmbeded" {
            
            if let TabFloatingTableViewController = segue.destinationViewController as? TabFloatingTableViewController {
                
                self.TabFloatingTableViewControllerRef = TabFloatingTableViewController
                
            }
        }
    }
}


extension TabViewController: TabTableViewDelegate {
    
    func defaultScreen() {
        
        // Default Empty Tab View
        if TabManager.sharedInstance.currentTab.lines.count < 1 {
            
            //            if orders.orderId.count < 1 {
            
            let tabView = self.view
            // Screen Bounds
            let windowWidth = self.view.bounds.size.width
            let windowHeight = self.view.bounds.size.height
            // Create View
            let windowView = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
            windowView.backgroundColor = UIColor.whiteColor()
            windowView.layer.zPosition = 98
            // Create TRDM Logo
            let TRDMLogo = "secondary-logomark-03_rgb_600_600"
            let TRDMImage = UIImage(named: TRDMLogo)
            let TRDMImageView = UIImageView(image: TRDMImage)
            TRDMImageView.frame = CGRectMake(0, 0, windowWidth * 0.8, windowWidth * 0.8)
            TRDMImageView.frame.origin.y = windowHeight / 6
            TRDMImageView.frame.origin.x = windowWidth * 0.1
            TRDMImageView.alpha = 0.1
            TRDMImageView.layer.zPosition = 99
            // Create Message Text View
            let messageTextView = UITextView(frame: CGRectMake(0, 0, windowWidth * 0.7, windowWidth / 2))
            messageTextView.frame.origin.y = windowHeight * 0.65
            messageTextView.frame.origin.x = windowWidth * 0.15
            messageTextView.text = "Looks like you don't have any items on your tab."
            messageTextView.font = UIFont.basicFont(16)
            messageTextView.textColor = UIColor.grayColor()
            messageTextView.userInteractionEnabled = false
            messageTextView.textAlignment = .Center
            messageTextView.layer.zPosition = 99
            // Create Back To Menu Button
            let menuButton = UIButton(frame: CGRectMake(0, 0, windowWidth * 0.8, windowHeight / 10))
            menuButton.frame.origin.y = windowHeight * 0.75
            menuButton.frame.origin.x = windowWidth * 0.1
            menuButton.setTitle("Back to Menu", forState: .Normal)
            menuButton.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
            menuButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            menuButton.titleLabel?.font = UIFont.scriptFont(24)
            menuButton.layer.cornerRadius = 12.0
            menuButton.clipsToBounds = true
            menuButton.addTarget(self, action: #selector(TabViewController.backToMenu), forControlEvents: UIControlEvents.TouchUpInside)
            menuButton.layer.zPosition = 99
            
            
            // Add Created Views
            tabView.addSubview(windowView)
            tabView.addSubview(TRDMImageView)
            tabView.addSubview(messageTextView)
            tabView.addSubview(menuButton)
            
            //        }
            
        }
    }
}