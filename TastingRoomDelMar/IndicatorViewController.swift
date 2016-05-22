//
//  IndicatorViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 5/20/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class IndicatorViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var IndicatorPopoverViewControllerRef: IndicatorPopoverViewController?
    
    
    // -----
    override func viewDidLoad() {
        super.viewDidLoad()


    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func showIndicator(sender: AnyObject) {
        
        self.performSegueWithIdentifier("trdmIndicator", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get Screen Size
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        // Tasting Room Del Mar Indicator
        if segue.identifier == "trdmIndicator" {
            let vc = segue.destinationViewController as! IndicatorPopoverViewController
            
            vc.preferredContentSize = CGSizeMake(screenWidth*0.60, screenWidth*0.60)
            
            // Set Controller
            let controller = vc.popoverPresentationController
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                controller!.sourceView = self.view
                controller!.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 0, 0)
                controller?.delegate = self
            }
        }
    }
    
    // PRESENTATION CONTROLLER DATA SOURCE
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        // Remove Opaque Window
//        AnimationManager.sharedInstance.opaqueWindow(self)
        
        print("Popover closed.")
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
        
    }
    
    
    
    
}


extension IndicatorViewController: IndicatorPopoverViewDelegate {
    
    
    
}
