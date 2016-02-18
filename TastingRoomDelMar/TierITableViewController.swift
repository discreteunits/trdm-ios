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
import ParseFacebookUtilsV4

var route = [PFObject]()

class TierITableViewController: UITableViewController, ENSideMenuDelegate {

    var tierIArray = [PFObject]()
    
    @IBOutlet weak var tabIcon: UIBarButtonItem!
    
    var nav: UINavigationBar?
    
    var locationFlyoutView = UIView()
    var windowView = UIView()
    var locationLabel = UILabel()
    var delMarLabel = UILabel()
    var addressTextView = UITextView()
    var TRDMLogo = String()
    var TRDMImage = UIImage()
    var TRDMImageView = UIImageView()
    
// ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Items Indicator
        TabManager.sharedInstance.addItemsIndicator()

        // Fetch Credit Cards
        if PFUser.currentUser()!.objectId != "" {
            getCards()
        }
        
        // Animation
        animateTable()
        
        // Check if user is signed in with Facebook
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            getFBUserData()
            print("User signed in with Facebook.")
            
        }
        
        // Sync Tab - Create or Find
        TabManager.sharedInstance.syncTab(TabManager.sharedInstance.currentTab.id)
        
        // TIER 1 QUERY
        tierIQuery()

        // FLYOUT MENU
        self.sideMenuController()?.sideMenu?.delegate = self

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            

            
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.layer.zPosition = 9
   
            self.navigationItem.hidesBackButton = true
            var newBackButton = UIBarButtonItem(title: "Del Mar", style: UIBarButtonItemStyle.Plain, target: self, action: "locationFlyout:")
            
            // Center Image Via
            let fixedItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            fixedItem.width = 25.0
            
            // Set Both Left Bar Button Items
            self.navigationItem.leftBarButtonItems = [newBackButton, fixedItem]
            
            
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "NexaRustScriptL-00", size: 20)!], forState: UIControlState.Normal)
                        
            // Set Tasting Room Logo As Title
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
            imageView.frame.origin.x = 0
            
            
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "Typographic-deconstructed_rgb_600_120")
            imageView.image = image
            navigationItem.titleView = imageView
            
            

            
            // RESET ROUTE
            route.removeAll()
            print("Route Reset: \(route)")
            
        }
        
    }
    
    func slideInFromLeft(duration: NSTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        
        let slideInFromLeftTransition = CATransition()
        
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        self.view.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        
    }
    
    // Location Flyout Menu
    func locationFlyout(sender: UIBarButtonItem) {
        
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
            
            
            self.locationFlyoutView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.locationFlyoutView.alpha = 1
            
            self.windowView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.windowView.alpha = 1
            
            self.locationLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.locationLabel.alpha = 1
            
            self.delMarLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.delMarLabel.alpha = 1
            
            self.addressTextView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.addressTextView.alpha = 1
            
//                        self.TRDMImageView.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }) { (succeeded: Bool) -> Void in
                if succeeded {

     
                    // Create Black Window
                    self.locationFlyoutView = self.view
                    
                    let windowWidth = self.view.bounds.size.width - 20
                    let windowHeight = self.view.bounds.size.height
                    self.windowView = UIView(frame: CGRectMake(0, 0, windowWidth * 0.78, windowHeight))
                    self.windowView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                    self.windowView.layer.zPosition = 99999
                    self.windowView.tag = 11
                    
                    // Create Location Label
                    self.locationLabel = UILabel(frame: CGRectMake(8, 8, windowWidth / 2, 21))
                    self.locationLabel.text = "Our Locations"
                    self.locationLabel.font = UIFont(name: "NexaRustScriptL-00", size: 24)
                    self.locationLabel.layer.zPosition = 999999
                    self.locationLabel.textColor = UIColor.whiteColor()
                    self.locationLabel.tag = 12
                    
                    // Create Location Title
                    self.delMarLabel = UILabel(frame: CGRectMake(8, 40, windowWidth / 2, 21))
                    self.delMarLabel.text = "Del Mar"
                    self.delMarLabel.font = UIFont(name: "NexaRustScriptL-00", size: 20)
                    self.delMarLabel.layer.zPosition = 999999
                    self.delMarLabel.textColor = UIColor.whiteColor()
                    self.delMarLabel.tag = 13
                    
                    
                    // Create Location Address
                    self.addressTextView = UITextView(frame: CGRectMake(8, 60, windowWidth / 3 , 200))
                    self.addressTextView.text = "1435 Camino Del Mar Del Mar, CA 92014 858.232.6545"
                    self.addressTextView.userInteractionEnabled = false
                    
                    self.addressTextView.font = UIFont(name: "BebasNeueRegular", size: 16)
                    self.addressTextView.textColor = UIColor.whiteColor()
                    self.addressTextView.backgroundColor = UIColor.blackColor()
                    self.addressTextView.layer.zPosition = 999999
                    self.addressTextView.tag = 14
                    
                    // TRDM Logo Position
                    let screenSize: CGRect = UIScreen.mainScreen().bounds
                    let screenWidth = screenSize.width
                    let screenHeight = screenSize.height
                    
                    self.TRDMLogo = "secondary-logomark-white_rgb_600_600.png"
                    self.TRDMImage = UIImage(named: self.TRDMLogo)!
                    self.TRDMImageView = UIImageView(image: self.TRDMImage)
                    self.TRDMImageView.frame = CGRectMake(0, 0,screenWidth / 2, screenWidth / 2)
                    self.TRDMImageView.frame.origin.y = (screenHeight / 1.6 )
                    self.TRDMImageView.frame.origin.x = 16
                    self.TRDMImageView.alpha = 0.5
                    self.TRDMImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI + M_PI_2 + M_PI_4))
                    self.TRDMImageView.layer.zPosition = 999999
                    self.TRDMImageView.tag = 15
                
                
                
                    if let viewWithTag = self.locationFlyoutView.viewWithTag(11) {
                        
                        viewWithTag.removeFromSuperview()
                        
                        let subViews = self.view.subviews
                        for subview in subViews {
                            if subview.tag == 12 {
                                subview.removeFromSuperview()
                            } else if subview.tag == 13 {
                                subview.removeFromSuperview()
                            } else if subview.tag == 14 {
                                subview.removeFromSuperview()
                            } else if subview.tag == 15 {
                                subview.removeFromSuperview()
                            }
                            
                        }
                        
                        
                    } else {
                        
                        self.locationFlyoutView.addSubview(self.windowView)
                        self.view.addSubview(self.locationLabel)
                        self.view.addSubview(self.delMarLabel)
                        self.view.addSubview(self.addressTextView)
                        self.view.addSubview(self.TRDMImageView)
                        
                        
                    }
                
                }
                
        }
    
    }
    

    
    
    
    @IBAction func openTab(sender: AnyObject) {
        
        TabManager.sharedInstance.removeItemsIndicator()
        
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
        
        for var index = 0; index < route.count; ++index {
            print("The Route has been increased to: \(route[index]["name"]).")
        }
        print("-----------------------")
        
        self.performSegueWithIdentifier("tierII", sender: self)

    }
    
    
    // Get Card CLOUDCODE FUNCTION CALL FETCH
    func getCards() {
        
        dispatch_async(dispatch_get_main_queue()){
            
            // Get User Card via User Object ID
            let card = CardManager.sharedInstance.fetchCards(TabManager.sharedInstance.currentTab.userId)
            CardManager.sharedInstance.currentCustomer.orderId.append(String(card))
        
        }
        
    }
    
// Facebook Graph Requests
    func getFBUserData() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender, email, birthday"])
        graphRequest.startWithCompletionHandler( { (connection, result, error) -> Void in
    
            if error != nil {
                
                print("----------------")
                print("Graph Request Returned Error: \(error)")
            
            } else if let result = result {
                
                print("----------------")
                print("Graph Request Returned")
                
                // Assign Graph Request Parameters To PFUser Object
                PFUser.currentUser()?["username"] = result["email"]
                print("Username: \(result["email"] as! String)")
                PFUser.currentUser()?["email"] = result["email"]
                print("Email: \(result["email"] as! String)")
                PFUser.currentUser()?["firstName"] = result["first_name"]
                print("First Name: \(result["first_name"] as! String)")
                PFUser.currentUser()?["lastName"] = result["last_name"]
                print("Last Name: \(result["last_name"] as! String)")
                
//                PFUser.currentUser()?["name"] = result["name"]
//                PFUser.currentUser()?["gender"] = result["gender"]
//                PFUser.currentUser()?["birthday"] = result["birthday"]

                PFUser.currentUser()?.saveInBackground()
                
                // Get and Save FB Profile Picture To Parse
                let userId = result["id"] as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let fbPicUrl = NSURL(string: facebookProfilePictureUrl) {
                    
                    if let data = NSData(contentsOfURL: fbPicUrl) {
                        
                        // Show FB Profile Pic
//                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile: PFFile = PFFile(data: data)!
                        PFUser.currentUser()?["image"] = imageFile
                        PFUser.currentUser()?.saveInBackground()
                        
                        print("----------------")

                    }
                
                }
                
            }
    
        })
    
    }

    // Fly Up Table Cells Animation
    func animateTable() {
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.3 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .Repeat, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
}



