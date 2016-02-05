//
//  TabViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import ParseCrashReporting

class TabViewController: UIViewController {

    var nav: UINavigationBar?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!

    var TabTableViewControllerRef: TabTableViewController?

// ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAV BAR STYLES
        
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "My Tab"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menu(sender: AnyObject) {
        
//        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
        
        performSegueWithIdentifier("backToMenu", sender: self)
        
    }

    
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "tabTableEmbeded" {
            
            if let TabTableViewController = segue.destinationViewController as? TabTableViewController {
                
                self.TabTableViewControllerRef = TabTableViewController
                TabTableViewController.containerViewController = self
                TabTableViewController.delegate = self
                
                
            } 
            
        }
        
        
    }


}


extension TabViewController: TabTableViewDelegate {
    
}