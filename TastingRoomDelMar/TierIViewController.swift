//
//  TierIViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4
import Alamofire
import SwiftValidator
import SlideMenuControllerSwift


class TierIViewController: UIViewController {
    
    var nav: UINavigationBar?
    
// ---------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            nav?.topItem!.title = "Tasting Room"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "Helvetica Neue", size: 20)!]
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
