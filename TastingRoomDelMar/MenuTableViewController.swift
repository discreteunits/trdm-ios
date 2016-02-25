//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.blackColor()
        tableView.layer.borderWidth = 0
//        tableView.layer.zPosition = 100
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)

        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width / 2
        let screenHeight = screenSize.height / 2
        
        // TRDM Logo Position
        let TRDMLogo = "secondary-logomark-white_rgb_600_600.png"
        let image = UIImage(named: TRDMLogo)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRectMake(0, 0,screenWidth, screenWidth)
        imageView.frame.origin.y = (screenHeight * 1.20)
        imageView.frame.origin.x = (screenWidth / 3)
        imageView.alpha = 0.5
        imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2 + M_PI_4))
        
        self.view.addSubview(imageView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        let menuArray = ["Menu", "Events", "Tab", "Payment", "Settings"]
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 24)
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = "\(menuArray[indexPath.row])"
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Selected row: \(indexPath.row)")
        
//        if (indexPath.row == selectedMenuItem) {
//            return
//        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController

        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TierI")
            
                selectedMenuItem = 0
                route.removeAll()
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Events")
            destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            destViewController.modalPresentationStyle = .CurrentContext

            let rootVC = sideMenuController() as! UIViewController
            rootVC.presentViewController(destViewController, animated: true, completion: nil)
            
            // Remove Items Indicator
            TabManager.sharedInstance.removeItemsIndicator()
            
                selectedMenuItem = 0
                TabManager.sharedInstance.totalCellCalculator()
            break
        case 2:
            let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabStoryboard", bundle: nil)

            destViewController = tabStoryboard.instantiateViewControllerWithIdentifier("Tab")
            destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            destViewController.modalPresentationStyle = .CurrentContext
            
            let rootVC = sideMenuController() as! UIViewController
            rootVC.presentViewController(destViewController, animated: true, completion: nil)
            
            // Remove Items Indicator
            TabManager.sharedInstance.removeItemsIndicator()
            
                selectedMenuItem = 0
            break
        case 3:
            let paymentStoryboard: UIStoryboard = UIStoryboard(name: "PaymentStoryboard", bundle: nil)

            destViewController = paymentStoryboard.instantiateViewControllerWithIdentifier("Payment")
            destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            destViewController.modalPresentationStyle = .CurrentContext
            
            let rootVC = sideMenuController() as! UIViewController
            rootVC.presentViewController(destViewController, animated: true, completion: nil)
            
            // Remove Items Indicator
            TabManager.sharedInstance.removeItemsIndicator()
            
                selectedMenuItem = 0
            break
        default:
            let settingsStoryboard: UIStoryboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)

            destViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("Settings")
            destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            destViewController.modalPresentationStyle = .CurrentContext
            
            let rootVC = sideMenuController() as! UIViewController
            rootVC.presentViewController(destViewController, animated: true, completion: nil)
            
            // Remove Items Indicator
            TabManager.sharedInstance.removeItemsIndicator()
            
                selectedMenuItem = 0
            break
        }

        sideMenuController()?.setContentViewController(destViewController)
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
