//
//  TierIIViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/12/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TierIIViewController: UIViewController, ENSideMenuDelegate {
    
    var nav: UINavigationBar?
    
// ---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.topItem!.title = "Dine In"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        
        toggleSideMenuView()

    }



}
