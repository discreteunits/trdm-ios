//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit
import Parse


class MenuTableViewController: UITableViewController, ENSideMenuDelegate {
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
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
        imageView.frame = CGRectMake(0, 0,screenWidth * 0.80, screenWidth * 0.80)
        imageView.frame.origin.y = (screenHeight * 1.32)
        imageView.frame.origin.x = (screenWidth * 0.23)
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
        
        if PFUser.currentUser()?["firstName"] != nil {
            return 5
        } else {
            return 2
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        var menuArray = [String]()
        
        // ----- Logged In Trigger -----
        if PFUser.currentUser()?["firstName"] != nil {
            
            menuArray = ["Menu", "Tab", "History", "Payment", "Settings"]
            
        } else {
            
            menuArray = ["Menu", "Home"]
            
        }
        // ----- END -----
        
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.scriptFont(24)
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
        
        if printFlag {
            print("Selected row: \(indexPath.row)")
        }
        
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
                RouteManager.sharedInstance.resetRoute()
            break
        case 1:
            
            // ----- Logged In Trigger -----
            // TAB
            if PFUser.currentUser()?["firstName"] != nil {

                let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabStoryboard", bundle: nil)

                destViewController = tabStoryboard.instantiateViewControllerWithIdentifier("Tab")
                destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                destViewController.modalPresentationStyle = .CurrentContext
                
                
                if let rootVC = sideMenuController() as? UIViewController {
                    
//               let rootVC = sideMenuController() as! UIViewController
                    rootVC.presentViewController(destViewController, animated: true, completion: nil)
                    
                } else {
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = mainStoryboard.instantiateViewControllerWithIdentifier("Menu")
                    vc.presentViewController(destViewController, animated: true, completion: nil)
                    
                }
                
                
                // Remove Items Indicator
                TabManager.sharedInstance.removeItemsIndicator()
                
                selectedMenuItem = 0
                break
                
                
            } else {
                
                
                // HOME
                let signupStoryboard: UIStoryboard = UIStoryboard(name: "SignupStoryboard", bundle: nil)
                destViewController = signupStoryboard.instantiateViewControllerWithIdentifier("Landing") as UIViewController
                
                let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let rootView: UIViewController = UIViewController()
                appDel.window?.rootViewController = rootView
                
                rootView.presentViewController(destViewController, animated: true, completion: nil)
                
                RouteManager.sharedInstance.resetRoute()
                selectedMenuItem = 0
                break
   
                
            }
            

        case 2:

                let historyStoryboard: UIStoryboard = UIStoryboard(name: "HistoryStoryboard", bundle: nil)
            
                destViewController = historyStoryboard.instantiateViewControllerWithIdentifier("History")
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
  
}


