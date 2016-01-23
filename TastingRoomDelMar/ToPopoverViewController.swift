//
//  PopOverViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/15/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class ToPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var popover: UIPopoverController?
    
    @IBAction func popover(sender: AnyObject) {
        self.performSegueWithIdentifier("showPopover", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemConfigPopover" {
            var vc = segue.destinationViewController as! UIViewController
            
            var controller = vc.popoverPresentationController
            
            controller!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            if controller != nil {
                
                controller?.delegate = self
                
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
