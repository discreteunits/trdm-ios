//
//  PopOverViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/15/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var popover: UIPopoverController?
    
    @IBAction func popover(sender: AnyObject) {
        self.performSegueWithIdentifier("showPopover", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPopover" {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
