//
//  TierIViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TierIViewController: UIViewController, ENSideMenuDelegate {
    
    @IBOutlet weak var dineInButton: UIButton!
    @IBOutlet weak var takeOutButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    
    var nav: UINavigationBar?
    
// ---------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuController()?.sideMenu?.delegate = self

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
        
        let optionsArray = [dineInButton, takeOutButton, eventsButton]
        
        for index in optionsArray {
            index.layer.borderWidth = 1;
            index.layer.borderColor = UIColor.lightGrayColor().CGColor
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        
        toggleSideMenuView()

    }
    
    @IBAction func dineIn(sender: AnyObject) {
        self.performSegueWithIdentifier("toTierII", sender: self)
    }
    
    @IBAction func takeOut(sender: AnyObject) {
        self.performSegueWithIdentifier("toTierII", sender: self)
    }
    @IBAction func events(sender: AnyObject) {
        self.performSegueWithIdentifier("toTierII", sender: self)
    }

}
