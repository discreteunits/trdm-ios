//
//  SettingsEditViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SettingsEditViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var nav: UINavigationBar?
    
    var passedTrigger: String!

    var editTitle: String!
    var editMessage: String!
    var editValue: String!
    
    var SettingsEditTableViewControllerRef: SettingsEditTableViewController?

    
// -------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = passedTrigger
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SettingsEditEmbeded" {
            
            if let SettingsEditTableViewController = segue.destinationViewController as? SettingsEditTableViewController {
                
                self.SettingsEditTableViewControllerRef = SettingsEditTableViewController
                
                SettingsEditTableViewController.delegate = self
            }
            
        }
        
    }

    
    func valueToEdit() {
        
        // Decide editTitle, editMessage, editValue
        if passedTrigger == "First name" {
            
        } else if passedTrigger == "Last name" {
            
        } else if passedTrigger == "mobile number" {
            
        } else if passedTrigger == "email" {
            
        } else if passedTrigger == "password" {
            
        }
        
    }

}

extension SettingsEditViewController: SettingsEditTableViewDelegate {
    
}
