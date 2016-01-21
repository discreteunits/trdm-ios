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

class TierIVViewController: UIViewController, ENSideMenuDelegate {

    var nav: UINavigationBar?
    
    var TierIVCollectionViewControllerRef: TierIVCollectionViewController?
    var TierIVTableViewControllerRef: TierIVTableViewController?
    
    var tierIVCollectionArray = [PFObject]()
    var tierIVTableArray = [PFObject]()

    var tagsArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsArrayCreation()
        tierIVCollectionQuery()
        tierIVTableQuery()
        
// FLYOUT MENU
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
// NAV BAR STYLES
        
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "primary-logotype-05_rgb_600_600")
            imageView.image = image
            navigationItem.titleView = imageView
            
// SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            let lastWindow = route[1]["name"]
            
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "\(lastWindow)", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
            self.navigationItem.leftBarButtonItem = newBackButton;
            
        }
    }
    
// NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        route.removeAtIndex(2)
        print("THE ROUTE IS NOW: \(route)")
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                TierIVCollectionViewController.tierIVCollectionArray = tierIVCollectionArray

                
            }
            
        } else if segue.identifier == "TierIVTableEmbeded" {
            
            if let TierIVTableViewController = segue.destinationViewController as? TierIVTableViewController {
                
                self.TierIVTableViewControllerRef = TierIVTableViewController
                TierIVTableViewController.delegate = self
                
                TierIVTableViewController.tierIVTableArray = tierIVTableArray
                
            }
            
        }
        
    }
    
}

extension TierIVViewController: TierIVCollectionViewDelegate, TierIVTableViewDelegate {
    
// TAGS ARRAY CREATION
    func tagsArrayCreation() {
        
        for object in route as [PFObject]! {
            
            let tag = object["tag"] as! PFObject
            
            self.tagsArray.append(tag)
            print("LET IT BE KNOWN: \(tag)")
            print("\(tagsArray)")
            
        }
        
    }
    
// TIER 4 COLLECTION QUERY
    func tierIVCollectionQuery() {
        
        var classToBeQueried = String()
        
        // COLLECTION CLASSNAME CONDITION
        if route[1]["name"] as! String == "Vines" {
            classToBeQueried = "WineVarietals"
        } else if route[1]["name"] as! String == "Hops" {
            classToBeQueried = "BeerStyles"
        }
        
        
        let collectionQuery:PFQuery = PFQuery(className: classToBeQueried)
        collectionQuery.includeKey("tag")
        collectionQuery.whereKey("tier3", equalTo: route[2])
        collectionQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierIV collection retrieved \(objects!.count) objects.")
                
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    if object["tag"] != nil {
                    
                        if object["tag"]["state"] as! String == "active" {
                        
                            self.tierIVCollectionArray.append(object)
                        
                        }
                    
                    }
                    
                }
                
                self.TierIVCollectionViewControllerRef?.collectionView?.reloadData()
                print("TierIV Collection Query Completed with \(self.tierIVCollectionArray.count) objects.")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            
        }
        
    }

// TIER 4 TABLE QUERY
    func tierIVTableQuery() {
        
        let tableQuery:PFQuery = PFQuery(className:"Items")
        tableQuery.includeKey("tags")
        tableQuery.whereKey("tags", containsAllObjectsInArray: route)
        print("All Items Listed")
        tableQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierIV table retrieved \(objects!.count) objects.")
                
                // Do something with the found objects
                for object in objects! as [PFObject] {
                    
                    self.tierIVTableArray.append(object)
                    
                }
                
                self.TierIVTableViewControllerRef?.tableView.reloadData()
                print("The ITEMS ARRAY equals: \(self.tierIVTableArray)")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
        }
    }

}

