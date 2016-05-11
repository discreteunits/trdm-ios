//
//  SettingsTextViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SettingsTextViewController: UIViewController {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var webviewInstance: UIWebView!
    
    var passedTrigger: String!
    var nav: UINavigationBar?

    // -----
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = passedTrigger
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
            //            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< Settings", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingsEditViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont.scriptFont(20)], forState: UIControlState.Normal)
            
            
        }
        

        
        if passedTrigger == "Privacy Policy" {
            
            webviewInstance.loadRequest(NSURLRequest(URL: NSURL(string:"https://www.tastingroomdelmar.com/privacy")!))
            
        } else if passedTrigger == "Terms of Use" {
            
//            webviewInstance.loadRequest(NSURLRequest(URL: NSURL(string:"https://www.google.com")!))
            
            webviewInstance.loadRequest(NSURLRequest(URL: NSURL(string:"http://www.tastingroomdelmar.com/terms")!))
            
        }
    }
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
