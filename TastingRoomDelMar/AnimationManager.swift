//
//  AnimationManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/25/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class AnimationManager: NSObject {
    
    static let sharedInstance = AnimationManager()
    
    // ----------
    
    override init() {
        super.init()
        
        //Initialize
        
    }

    func showButtonVertical(view: UIViewController, button:UIButton ) {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            button.transform = CGAffineTransformMakeTranslation(0, -button.frame.height + 69)
            button.alpha = 1
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    button.hidden = false
                    
                }
                
        }
        
    }
    
    func hideButtonVertical(view: UIViewController, button: UIButton) {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            button.transform = CGAffineTransformIdentity
            button.alpha = 0
            
            }) { (succeeded: Bool) -> Void in
                
                if succeeded {
                    button.hidden = true
                    
                }
                
        }
        
    }
    
    
    
}
