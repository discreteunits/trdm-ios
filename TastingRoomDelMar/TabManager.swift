//
//  TabManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/28/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

class TabManager: NSObject {

    
    func checkUser() -> PFObject{
        
        if PFUser.currentUser() != nil {
            
            // Current User Exists
            print("User Logged In")
            
            
        } else {
            
            // No Current User
            print("No User Found")
            
            PFAnonymousUtils.logInWithBlock({ (user: PFUser?, error: NSError?) -> Void in
                
                if error != nil || user == nil {
                    print("Anonymous login failed.")
                } else {
                    print("Anonymous user logged in.")
                }
                
            })
            
        }
        
        return PFUser.currentUser()!
        
    }
    
    
    
    
    
//    func syncTab(user: PFUser) {
//        
//        if orderObject == nil {
//            
//            // Create New orderObject
//            
//        } else {
//            
//            if orderObject["user"] != user {
//            
//                print("The current orderObject stored locally is not the current users orderObject.")
//                // Delete orderObject
//            
//                // Create New orderObject
//            
//            } else {
//            
//                // Run CloudCode syncTab
//            
//            }
//        
//        }
//        
//    }
    
    
    
    
    
    
    
    
    
    
    
}
