//
//  TierITableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/12/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import Bond

var route = [PFObject]()

class TierITableViewController: UITableViewController, ENSideMenuDelegate {

    var tierIArray = [PFObject]()
        
    @IBOutlet weak var tabIcon: UIBarButtonItem!
    
    var nav: UINavigationBar?
    
// ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Sync Tab - Create or Find
        TabManager.sharedInstance.syncTab(TabManager.sharedInstance.currentTab.id)
        
        // Spoof CardManager and Customer
        CardManager.sharedInstance
        
        
        // TIER 1 QUERY
        tierIQuery()

        // FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
   
            self.navigationItem.hidesBackButton = true
            var newBackButton = UIBarButtonItem(title: "Del Mar", style: UIBarButtonItemStyle.Plain, target: self, action: "locationFlyout:")
            self.navigationItem.leftBarButtonItem = newBackButton;
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "NexaRustScriptL-00", size: 20)!], forState: UIControlState.Normal)
            
            // Set Tasting Room Logo As Title
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "Typographic-deconstructed_rgb_600_120")
            imageView.image = image
            navigationItem.titleView = imageView
            

            
            // RESET ROUTE
            route = []
            
        }
        
    }
    
    func locationFlyout(sender: UIBarButtonItem) {
        
        // Create Black Window
        let locationFlyoutView = self.view
        
        let windowWidth = self.view.bounds.size.width - 20
        let windowHeight = self.view.bounds.size.height
        
        let windowView = UIView(frame: CGRectMake(0, 0, windowWidth / 2, windowHeight))
        windowView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        windowView.tag = 12
        
        // Create Location Title
        var locationLabel = UILabel(frame: CGRectMake(8, 20, windowWidth / 2, 21))
        //        locationLabel.center = CGPointMake(40, 180)
        //        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.text = "Del Mar"
        locationLabel.font = UIFont(name: "NexaRustScriptL-00", size: 20)
        locationLabel.layer.zPosition = 9999
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.tag = 13
        
        
        // Create Location Address
        let addressTextView = UITextView(frame: CGRectMake(8, 40, windowWidth / 3 , 200))
        addressTextView.text = "1435 Camino Del Mar Del Mar, CA 92014 858.232.6545"
        addressTextView.font = UIFont(name: "BebasNeueRegular", size: 16)
        addressTextView.textColor = UIColor.whiteColor()
        addressTextView.backgroundColor = UIColor.blackColor()
        addressTextView.tag = 14
        
        // TRDM Logo Position
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width / 3
        let screenHeight = screenSize.height / 1.4
        
        let TRDMLogo = "secondary-logomark-white_rgb_600_600.png"
        let image = UIImage(named: TRDMLogo)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRectMake(0, 0,screenWidth, screenWidth)
        imageView.frame.origin.y = (screenHeight)
        imageView.frame.origin.x = (screenWidth / 3)
        imageView.alpha = 0.5
        imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2 + M_PI_4))
        imageView.tag = 15
        
        
        
        if let viewWithTag = locationFlyoutView.viewWithTag(12) {
            
            viewWithTag.removeFromSuperview()
            
            let subViews = self.view.subviews
            for subview in subViews {
                if subview.tag == 13 {
                    subview.removeFromSuperview()
                } else if subview.tag == 14 {
                    subview.removeFromSuperview()
                } else if subview.tag == 15 {
                    subview.removeFromSuperview()
                }
                
            }
            
            
        } else {
            
            locationFlyoutView.addSubview(windowView)
            self.view.addSubview(locationLabel)
            self.view.addSubview(addressTextView)
            self.view.addSubview(imageView)


        }
        

        
    }
    
    
    @IBAction func openTab(sender: AnyObject) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Tab")
        destViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        destViewController.modalPresentationStyle = .CurrentContext
        
        let rootVC = sideMenuController() as! UIViewController
        rootVC.presentViewController(destViewController, animated: true, completion: nil)
        
        TabManager.sharedInstance.totalCellCalculator()
        
    }
    

    
// -----
// TIER 1 QUERY
// -----
    func tierIQuery() {
        
        let query:PFQuery = PFQuery(className:"Tier1")
        query.includeKey("tag")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierI retrieved \(objects!.count) objects.")
                
                // Do something with the found objects
                for object in objects! as [PFObject]! {
                    
                    if object["tag"]["state"] as! String == "active" {
                        
                        self.tierIArray.append(object)
                        
                    }
                    
                }
                
                self.tableView.reloadData()
                for i in self.tierIArray {
                    print("TierI Array: \(i["name"])")
                }
                print("-----------------------")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tierIArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tierIArray[indexPath.row]["name"] as? String
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 38.0)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let tableHeight = (tableView.bounds.size.height - 44.0)
        let numberOfCells: Int = tierIArray.count
        let numberOfCellsFloat = CGFloat(numberOfCells)
        let cellHeight = tableHeight / numberOfCellsFloat
        
        return cellHeight
        
    }

// FLYOUT TRIGGER
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

// ADD INDEX TO ROUTE
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        route.append(tierIArray[indexPath.row])
        
        print("The Route has been increased to: \(route[0]["name"])")
        print("-----------------------")
        
        self.performSegueWithIdentifier("tierII", sender: self)

    }

}
