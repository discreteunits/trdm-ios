//
//  PaymentAddViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class PaymentAddViewController: UIViewController {

    var nav: UINavigationBar?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var CardNumberTextField: UITextField!
    @IBOutlet weak var ExpTextField: UITextField!
    @IBOutlet weak var CVCTextField: UITextField!
    
    @IBOutlet weak var CardNumberLabel: UILabel!
    @IBOutlet weak var ExpLabel: UILabel!
    @IBOutlet weak var CVCLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
//            navigationTitle.title = "Add Payment"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "NexaRustScriptL-00", size: 24)!]
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
