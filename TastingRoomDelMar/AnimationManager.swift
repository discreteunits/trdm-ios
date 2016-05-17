//
//  AnimationManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/25/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

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
    
    func opaqueWindow(view: UIViewController) {
        
        let tierIVView = view.view
        
        let windowWidth = view.view.bounds.size.width
        let windowHeight = view.view.bounds.size.height
        
        let windowView = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        
        if let viewWithTag = tierIVView.viewWithTag(21) {
            
            viewWithTag.removeFromSuperview()
            
        } else {
            
            windowView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
            windowView.tag = 21
            tierIVView.addSubview(windowView)
            
        }
        
    }
    
    
    // Fly Up Table Cells Animation
    func animateTable(tableView: UITableView) {
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        // Original Settings
        // 1.5, delay: 0.05, usingSpringWithDamping: 0.8
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(0.6, delay: 0.1 * Double(index), usingSpringWithDamping: 1.2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut , animations: {
                
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                
                
                }, completion: nil)
            
            index = index + 1
            
        }

    }
    
    // Fade In/Out TableView
    func fade(tableView: UITableView, alpha: CGFloat) {

        UIView.animateWithDuration(0.2, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
            tableView.alpha = alpha
            }, completion: nil)
    }
 
}
