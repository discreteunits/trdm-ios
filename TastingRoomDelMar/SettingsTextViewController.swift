//
//  SettingsTextViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SettingsTextViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
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
            
        }
        
        titleLabel.text = passedTrigger
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.headerFont(28)
        
        if passedTrigger == "Privacy Policy" {
            
            webviewInstance.loadRequest(NSURLRequest(URL: NSURL(string:"https://www.tastingroomdelmar.com/privacy")!))
            
        } else if passedTrigger == "Terms of Use" {
            
            webviewInstance.loadRequest(NSURLRequest(URL: NSURL(string:"https://www.tastingroomdelmar.com/terms")!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
