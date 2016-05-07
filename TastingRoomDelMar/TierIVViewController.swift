//
//  TierIVViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/12/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import ParseCrashReporting

class TierIVViewController: UIViewController, ENSideMenuDelegate, UIPopoverPresentationControllerDelegate {

    var nav: UINavigationBar?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var popover: UIPopoverPresentationController?
    
    var TierIVCollectionViewControllerRef: TierIVCollectionViewController?
    var TierIVTableViewControllerRef: TierIVTableViewController?

    var tagsArray = [PFObject]()
    var tierIVCollectionArray = [PFObject]()
    var tierIVTableArray = [PFObject]()
    
    @IBOutlet weak var tierIVTableContainer: UIView!
    @IBOutlet weak var tierIVCollectionContainer: UIView!
    
    var bounds: CGRect!
    
    var notHarvest: String = String()
    
    
    @IBOutlet weak var tierIVCollectionView: UIView!
    

// ---------------
    override func isViewLoaded() -> Bool {
        
//        // ----- HARVEST OR EVENTS BEGIN ------
//        if route[0]["name"] as! String == "Events" {
//            notHarvest = ""
//        } else if route[1]["name"] as! String == "Harvest" {
//            notHarvest = ""
//        } else {
//            notHarvest = "CHOICE"
//        }
//        // ----- END -----
        
        

        
        // This is for going to tab from "Add To Tab" Alert
        if TabManager.sharedInstance.tierIVToTab {
            let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabStoryboard", bundle: nil)
            let vc = tabStoryboard.instantiateViewControllerWithIdentifier("Tab")
            TabManager.sharedInstance.tierIVToTab = false
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        return true
        
    }
    
    func productTypeToQuery() {
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            notHarvest = ""
        } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            notHarvest = ""
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            notHarvest = ""
        } else {
            notHarvest = "CHOICE"
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        let width = CGFloat(2.0)
        let border = CALayer()
        
        let frame = self.tierIVCollectionView.frame
        let collectionWidth = frame.size.width
        let collectionHeight = frame.size.height
        
        print("++++++++ Collection width: \(collectionWidth)")
        print("++++++++ Collection height: \(collectionHeight)")
        
        border.borderColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 0.4).CGColor
        border.frame = CGRect(x: 0, y:  collectionHeight + 8, width:  collectionWidth, height: 1)
        
        
        border.borderWidth = width
        self.tierIVCollectionView.layer.addSublayer(border)
        self.tierIVCollectionView.layer.masksToBounds = true
        
        
        
        productTypeToQuery()
        
        
        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            var navTitle = String()
            var lastWindow = String()
            
            if RouteManager.sharedInstance.TierOne!["skipToTier4"] as! Bool {
                navTitle = RouteManager.sharedInstance.TierOne!["name"] as! String
                lastWindow = navTitle
            } else if RouteManager.sharedInstance.TierTwo!["skipToTier4"] as! Bool {
                navTitle = RouteManager.sharedInstance.TierTwo!["name"] as! String
                lastWindow = RouteManager.sharedInstance.TierOne!["name"] as! String
            } else {
                navTitle = RouteManager.sharedInstance.TierThree!["name"] as! String
                lastWindow = RouteManager.sharedInstance.TierTwo!["name"] as! String
            }
            
            nav = navBar
            
            navigationTitle.title = navTitle
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< \(lastWindow)", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TierIVViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton;
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont.scriptFont(20)], forState: UIControlState.Normal)
            
        }
        
        print("------------Queries Completed------------")
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productTypeToQuery()
        
        bounds = self.view.bounds
        
        // Items Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.tagsArrayCreation()
            
            print("tagsArrayCreation Completed")
            
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            
            self.tierIVCollectionQuery()
            self.tierIVTableQuery()
            
            print("collection and table queries Completed")
            
        }
        
        // FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self
        
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        if RouteManager.sharedInstance.Route!.count == 1 {          // Jumped From TierOne
            RouteManager.sharedInstance.TierOne = nil
        } else if RouteManager.sharedInstance.Route!.count == 2 {   // Jumped From TierTwo
            RouteManager.sharedInstance.TierTwo = nil
        } else if RouteManager.sharedInstance.Route!.count == 4 {   // On TierFour With Collection Selection
            RouteManager.sharedInstance.TierThree = nil
            RouteManager.sharedInstance.TierFour = nil
        } else {                                                    // On TierFour Without Collection Selection
            RouteManager.sharedInstance.TierThree = nil
        }
 
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openTab(sender: AnyObject) {
        
        TabManager.sharedInstance.removeItemsIndicator()
        
        // Present Tab
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabStoryboard",bundle: nil)
        var destViewController : UIViewController
        
        destViewController = tabStoryboard.instantiateViewControllerWithIdentifier("Tab")
        destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        destViewController.modalPresentationStyle = .CurrentContext
        
        let rootVC = sideMenuController() as! UIViewController
        rootVC.presentViewController(destViewController, animated: true, completion: nil)
        
        TabManager.sharedInstance.totalCellCalculator()
        
    }
    
    
    // FLYOUT TRIGGER
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // PREPARE FOR SEGUE DATA TRANSFER
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "TierIVCollectionEmbeded" {
            
            if let TierIVCollectionViewController = segue.destinationViewController as? TierIVCollectionViewController {
                
                self.TierIVCollectionViewControllerRef = TierIVCollectionViewController
                TierIVCollectionViewController.delegate = self
                
                TierIVCollectionViewController.collectionArray = tierIVCollectionArray
                
                
                
                TierIVCollectionViewControllerRef?.collectionView?.reloadData()
                
            } else {
                
                print("Collection Data NOT Passed!")
                
            }
        }

        if segue.identifier == "TierIVTableEmbeded" {
            
            if let TierIVTableViewController = segue.destinationViewController as? TierIVTableViewController {
                
                self.TierIVTableViewControllerRef = TierIVTableViewController
                TierIVTableViewController.delegate = self
                
            } else {
                
                print("Table Data Not Passed!")
                
            }
        }
    }
}

extension TierIVViewController: TierIVCollectionViewDelegate, TierIVTableViewDelegate {
    
//    func removeTableCellLines() {
//        
//        self.TierIVTableViewControllerRef?.removeSubLayers()
//        
//    }
    
    func getViewBounds()  -> CGRect {
        
        bounds = UIScreen.mainScreen().bounds
        
        return bounds
        
    }
    
    func reloadTable() {
        
        self.TierIVTableViewControllerRef?.tableView.reloadData()

    }
    
    // TAGS ARRAY CREATION
    func tagsArrayCreation() {
        
        // Clean Up
        self.tagsArray.removeAll()
        
        // Set
        for object in RouteManager.sharedInstance.Route! as! [PFObject] {
            
            let tag = object["category"] as! PFObject
            
            self.tagsArray.append(tag)
            
        }
    }
    
    // TIER 4 COLLECTION QUERY
    func tierIVCollectionQuery() {
        
        self.TierIVCollectionViewControllerRef?.tierIVCollectionArray.removeAll()
            
        let collectionQuery:PFQuery = PFQuery(className: "Tier4")
        collectionQuery.includeKey("category")
        collectionQuery.orderByAscending("name")
        collectionQuery.includeKey("parentTiers")
        collectionQuery.whereKey("parentTiers", containedIn: RouteManager.sharedInstance.Route!)
        collectionQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierIV collection query retrieved: \(objects!.count) objects.")
                    
                for object in objects! as [PFObject]! {
                    if let product = object["category"] as? PFObject {
                        if product["state"] as! String == "active" {
                        
                            if !(self.TierIVCollectionViewControllerRef?.tierIVCollectionArray.contains(object))! {
                                self.TierIVCollectionViewControllerRef?.tierIVCollectionArray.append(object)
                            }
                            
                            if !(self.TierIVTableViewControllerRef?.tierIVTableArray.contains(object))! {
                                self.TierIVTableViewControllerRef?.tierIVCollectionArray.append(object["category"] as! PFObject)
                            }
                            
                        }
                    }
                }
                
                self.TierIVCollectionViewControllerRef?.collectionView?.reloadData()
                
                print("TierIV collection query appended: \(self.TierIVCollectionViewControllerRef!.tierIVCollectionArray.count) objects.")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }

    // TIER 4 TABLE QUERY
    func tierIVTableQuery() {
        
        self.TierIVTableViewControllerRef?.tierIVTableArray.removeAll()
        
        let tableQuery:PFQuery = PFQuery(className:"Product")
        tableQuery.includeKey("category")
        
        
        // Sort Order
        if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
            tableQuery.orderByAscending("name")
        } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
            tableQuery.orderByAscending("name")
        } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Harvest" {
            tableQuery.orderByAscending("sortOrder")
        } else {
            tableQuery.orderByAscending("name")
        }
        
        tableQuery.whereKey("categories", containsAllObjectsInArray: tagsArray)
        tableQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierIV table query retrieved: \(objects!.count) objects.")
                
                for object in objects! as [PFObject] {
                    
                    if object["stockAmount"] as! Int > 0 {
                    
                    if RouteManager.sharedInstance.TierOne!["name"] as! String == "Events" {
                        
                        if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                            self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                        } else {
                            print("This selection is already being shown.")
                        }
                        
                    } else if RouteManager.sharedInstance.TierOne!["name"] as! String == "Merch" {
                    
                        if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                            self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                        } else {
                            print("This selection is already being shown.")
                        }
                        
                    } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Hops" {
                        
                        if object["productType"] as! String == "CHOICE" {
                            if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                                self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                            } else {
                                print("This selection is already being shown.")
                            }
                        }
                        
                    } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "Vines" {
                        
                        if object["productType"] as! String == "CHOICE" {
                            if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                                self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                            } else {
                                print("This selection is already being shown.")
                            }
                        }
                        
                        
                        
                        
                        
                    } else if RouteManager.sharedInstance.TierTwo!["name"] as! String == "More" {
                        
//                        print("OBJECT EQUALS: \(object)")
                        
                        // Parent Product Route
                        if object["productType"] as! String == "CHOICE" {
                            
                            // Parent Product Route
                            if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                                self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                            } else {
                                print("This selection is already being shown.")
                            }
                            
                        // Subproduct Route
                        } else if object["productType"] as! String != "" {
                            
                            // Don't Show Subproducts
                            print("Subproduct Found: \(object["name"])")
                            
                            
                        // Produt Route
                        } else {
                            
                            // Product Route
                            if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                                self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                            } else {
                                print("This selection is already being shown.")
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        
 
                    } else {
                    // IF NOT HOPS or VINES
                        if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                            self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                        } else {
                            print("This selection is already being shown.")
                        }
                        
                    }
                }
                
//                AnimationManager.sharedInstance.animateTable((self.TierIVTableViewControllerRef!.tableView)!)
                    
                self.TierIVTableViewControllerRef!.tableView.reloadData()
                
                print("TierIV table query completed with:  \(self.TierIVTableViewControllerRef!.tierIVTableArray.count) objects.")
                }
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }
}

