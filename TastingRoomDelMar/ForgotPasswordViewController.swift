//
//  ForgotPasswordViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 5/14/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var forgotPasswordWebView: UIWebView!
    
    var nav: UINavigationBar?

    
    // --------
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "Forgot Password"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
            //            // SET NAV BACK BUTTON TO REMOVE LAST ITEM FROM ROUTE
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "< Sign Up", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingsEditViewController.back(_:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            self.navigationItem.leftBarButtonItem!.setTitleTextAttributes( [NSFontAttributeName: UIFont.scriptFont(20)], forState: UIControlState.Normal)
            
        }
        
        forgotPasswordWebView.loadRequest(NSURLRequest(URL: NSURL(string:"http://www.tastingroomdelmar.com/password-reset")!))
        
    }
    
    
    // NAV BACK BUTTON ACTION
    func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
