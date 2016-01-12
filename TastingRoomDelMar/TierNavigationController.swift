//
//  TierNavigationController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/7/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class TierNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// FLYOUT MENU
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MenuTableViewController(), menuPosition:.Right)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 260.0 // optional, default is 160
        //sideMenu?.bouncingEnabled = true
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }

}
