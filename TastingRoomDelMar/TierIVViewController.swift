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
    
    var notHarvest = String()

// ---------------
    override func isViewLoaded() -> Bool {

        if TabManager.sharedInstance.tierIVToTab {
            
            let tabStoryboard: UIStoryboard = UIStoryboard(name: "TabStoryboard", bundle: nil)
            
            let vc = tabStoryboard.instantiateViewControllerWithIdentifier("Tab")
            
            TabManager.sharedInstance.tierIVToTab = false
            
            self.presentViewController(vc, animated: true, completion: nil)

        }
        
        return true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // ----- HARVEST BEGIN ------
        if route[1]["name"] as! String == "Harvest" {
            // Do Nothing
            notHarvest = ""
        } else {
            notHarvest = "CHOICE"
        }
        // ----- END -----
        
        
        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = route[2]["name"] as! String
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
            
            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            let lastWindow = route[1]["name"]
            
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< \(lastWindow)", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TierIVViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton;
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "NexaRustScriptL-00", size: 20)!], forState: UIControlState.Normal)
            
        }
        
        // If Harvest - Remove Collection View
        let tierTwoSelection = route[1]["name"] as! String
        
        if printFlag {
            print("\(route[1]["name"]) Route Initiating New TierIV style.")
        }
        
        if tierTwoSelection == "Harvest" {
            
            tierIVCollectionContainer.hidden = true
            let screenWidth = self.view.bounds.width

            let views = ["view": self.view, "newView": tierIVTableContainer]
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[view]-(<=0)-[newView(\(screenWidth))]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
            view.addConstraints(horizontalConstraints)
         
        // If NOT Harvest
        } else 	{
            
        }
        
        
        if printFlag {
            print("------------Queries Completed------------")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bounds = self.view.bounds
        
        // Items Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.tagsArrayCreation()
            
            if printFlag {
                print("tagsArrayCreation Completed")
            }
            
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            self.tierIVCollectionQuery()
            self.tierIVTableQuery()
            
            if printFlag {
                print("collection and table queries Completed")
            }
            
        }
        
        // FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self
        
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        if route.count == 4 {
            route.removeAtIndex(3)
        }
        route.removeAtIndex(2)
        
        if printFlag {
            for index in 0 ..< route.count {
                print("The Route has been decreased to: \(route[index]["name"]).")
            }
            print("-----------------------")
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
                
                if printFlag {
                    print("Collection Data NOT Passed!")
                }
                
            }
            
        }

        if segue.identifier == "TierIVTableEmbeded" {
            
            if let TierIVTableViewController = segue.destinationViewController as? TierIVTableViewController {
                
                self.TierIVTableViewControllerRef = TierIVTableViewController
                TierIVTableViewController.delegate = self
                
            } else {
                
                if printFlag {
                    print("Table Data Not Passed!")
                }
                
            }
        
        }
        
    }
    
}

extension TierIVViewController: TierIVCollectionViewDelegate, TierIVTableViewDelegate {
    
    func getViewBounds()  -> CGRect {
                
        return bounds
        
    }
    
    
    func reloadTable() {
        
        self.TierIVTableViewControllerRef?.tableView.reloadData()

    }
    
    // TAGS ARRAY CREATION
    func tagsArrayCreation() {
        
        self.tagsArray.removeAll()
        
        for object in route as [PFObject]! {
            
            let tag = object["category"] as! PFObject
            
            self.tagsArray.append(tag)
            
        }
        
    }
    
    // TIER 4 COLLECTION QUERY
    func tierIVCollectionQuery() {
        
        self.TierIVCollectionViewControllerRef?.tierIVCollectionArray.removeAll()

        
        var classToBeQueried = String()
        
        // COLLECTION CLASSNAME CONDITION
        if route[1]["name"] as! String == "Vines" {
            classToBeQueried = "WineVarietal"
        } else if route[1]["name"] as! String == "Hops" {
            classToBeQueried = "BeerStyle"
        }
        
        if printFlag {
            print("Attempting to query \(classToBeQueried) for collection")
        }
            
        let collectionQuery:PFQuery = PFQuery(className: classToBeQueried)
        collectionQuery.includeKey("category")
        collectionQuery.whereKey("tier3", equalTo: route[2])
        collectionQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                if printFlag {
                    print("TierIV collection query retrieved: \(objects!.count) objects.")
                }
                    
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    if let product = object["category"] as? PFObject {
                        
                        if product["state"] as! String == "active" {
                        
                            self.TierIVCollectionViewControllerRef?.tierIVCollectionArray.append(object)
                            self.TierIVTableViewControllerRef?.tierIVCollectionArray.append(object["category"] as! PFObject)
                        
                        }
                    
                    }
                    
                }
                
                self.TierIVCollectionViewControllerRef?.collectionView?.reloadData()
                
                if printFlag {
                    print("TierIV collection query appended: \(self.TierIVCollectionViewControllerRef!.tierIVCollectionArray.count) objects.")
                }
                  
            } else {
                
                // Log details of the failure
                if printFlag {
                    print("Error: \(error!) \(error!.userInfo)")
                }
                
            }
            
        }
        
    }

    // TIER 4 TABLE QUERY
    func tierIVTableQuery() {
        
        self.TierIVTableViewControllerRef?.tierIVTableArray.removeAll()
        
        let tableQuery:PFQuery = PFQuery(className:"Product")
        tableQuery.includeKey("category")
        tableQuery.whereKey("productType", equalTo: notHarvest)
        tableQuery.whereKey("categories", containsAllObjectsInArray: tagsArray)
        tableQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                if printFlag {
                    print("TierIV table query retrieved: \(objects!.count) objects.")
                }
                
                // Do something with the found objects
                for object in objects! as [PFObject] {
                    
                    if !self.TierIVTableViewControllerRef!.tierIVTableArray.contains(object) {
                        
                        self.TierIVTableViewControllerRef?.tierIVTableArray.append(object)
                        


                    } else {
                        
                        if printFlag {
                            print("This selection is already being shown.")
                        }
                        
                    }
                    
                }
                
                AnimationManager.sharedInstance.animateTable((self.TierIVTableViewControllerRef!.tableView)!)
                
                if printFlag {
                    print("TierIV table query completed with:  \(self.TierIVTableViewControllerRef!.tierIVTableArray.count) objects.")
                }
                
            } else {
                
                // Log details of the failure
                if printFlag {
                    print("Error: \(error!) \(error!.userInfo)")
                }
                
            }
            
        }
        
    }
    

    
}

