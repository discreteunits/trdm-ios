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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// FLYOUT TRIGGER
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

    
// ----------------------
// QUERY FUNCTIONS
// ----------------------
//    func varietalsQuery() {
//        print("Varietal query fired")
//        
//    }
//    func itemsQuery() {
//        
//        print("Items query fired")
//        
//        let query:PFQuery = PFQuery(className:"WineVarietals")
//        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) varietals.")
//                
//                // Do something with the found objects
//                for object in objects as! [PFObject]! {
//                    print(object.objectId)
//                    self.varietalsArray.append(object["name"] as! String)
//                    
//                }
//                
//                print("\(self.varietalsArray)")
//                
//            } else {
//                
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//                
//            }
//            
//        }
//    }

}

