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
        let screenHeight = self.view.bounds.size.height
        
        let trdmIndicatorView = self.view
        trdmIndicatorView.layer.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).CGColor
        
        
        let trdmGifImage = UIImage.animatedImageNamed("spinner-", duration: 3.0)
        let trdmIndicatorImageView = UIImageView(image: trdmGifImage)

        
        trdmIndicatorImageView.frame = CGRectMake(0, 0,screenWidth * 0.3, screenWidth * 0.40)
        trdmIndicatorImageView.frame.origin.y = screenWidth * 0.1
        trdmIndicatorImageView.frame.origin.x = screenWidth * 0.15
        trdmIndicatorImageView.layer.zPosition = 9999999
        


        self.view.addSubview(trdmIndicatorImageView)

    
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
