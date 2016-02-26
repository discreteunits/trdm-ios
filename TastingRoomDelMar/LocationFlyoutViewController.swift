//
//  LocationFlyoutViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/9/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class LocationFlyoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Black Window
        let locationFlyout = self.view
        
        let windowWidth = self.view.bounds.size.width
        let windowHeight = self.view.bounds.size.height
        
        let windowView = UIView(frame: CGRectMake(0, 0, windowWidth / 2, windowHeight))
        windowView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        windowView.tag = 12
        locationFlyout.addSubview(windowView)
        
        // Create Location Title
        var locationLabel = UILabel(frame: CGRectMake(8, 100, windowWidth / 2, 21))
//        locationLabel.center = CGPointMake(40, 180)
//        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.text = "Del Mar"
        locationLabel.font = UIFont(name: "NexaRustScriptL-00", size: 20)
        locationLabel.layer.zPosition = 9999
        locationLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(locationLabel)
        

        // Create Location Address
        let addressTextView = UITextView(frame: CGRectMake(8, 120, windowWidth / 3 , 200))
        addressTextView.text = "1435 Camino Del Mar Del Mar, CA 92014 858.232.6545"
        addressTextView.font = UIFont(name: "BebasNeueRegular", size: 16)
        addressTextView.textColor = UIColor.whiteColor()
        addressTextView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(addressTextView)
        

        
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
