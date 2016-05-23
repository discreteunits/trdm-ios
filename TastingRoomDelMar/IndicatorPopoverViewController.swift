//
//  IndicatorPopoverViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 5/20/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

@objc
protocol IndicatorPopoverViewDelegate {
    
}

class IndicatorPopoverViewController: UIViewController {

    var delegate: IndicatorPopoverViewDelegate? 
    
    // -----
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Bounds
        let screenWidth = self.view.bounds.size.width
        
        
        
        
        let indicatorWindowView = UIView(frame:CGRectMake(0, 0, screenWidth * 0.5, screenWidth * 0.5))
        indicatorWindowView.frame.origin.y = screenWidth * 0.25
        indicatorWindowView.frame.origin.x = screenWidth * 0.25
        indicatorWindowView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        indicatorWindowView.layer.zPosition = 999999
        indicatorWindowView.clipsToBounds = true
        indicatorWindowView.layer.cornerRadius = 4.0
        indicatorWindowView.tag = 1336
        

        
        
        let trdmGifImage = UIImage.animatedImageNamed("spinner-", duration: 4.0)
        let trdmIndicatorImageView = UIImageView(image: trdmGifImage)
        trdmIndicatorImageView.frame = CGRectMake(0, 0,screenWidth * 0.15, screenWidth * 0.25)
//        trdmIndicatorImageView.frame.origin.y = screenWidth * 0.05
//        trdmIndicatorImageView.frame.origin.x = screenWidth * 0.05
        

        
        
        
        trdmIndicatorImageView.layer.zPosition = 9999999
        trdmIndicatorImageView.tag = 1337


        self.view.addSubview(indicatorWindowView)
        indicatorWindowView.addSubview(trdmIndicatorImageView)
        
        
        let xConstraint = NSLayoutConstraint(item: trdmIndicatorImageView, attribute: .CenterX, relatedBy: .Equal, toItem: indicatorWindowView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: trdmIndicatorImageView, attribute: .CenterY, relatedBy: .Equal, toItem: indicatorWindowView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activateConstraints([xConstraint, yConstraint])

    
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
