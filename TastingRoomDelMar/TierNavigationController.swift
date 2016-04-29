//
//  TierNavigationController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/7/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TierNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {
    
    var screenSize = CGRect()
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // FLYOUT MENU
        sideMenuController()
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MenuTableViewController(), menuPosition:.Right)
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = screenWidth * 0.58 // optional, default is 160
        //sideMenu?.bouncingEnabled = true
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
