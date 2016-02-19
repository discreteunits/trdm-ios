//
//  AppDelegate.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4
import Stripe


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("0tK5OiiJtRoCxmlP61AdONeBO2rVPVKpxW3EVaZG",
            clientKey: "GB8OlPH1XWQTCHo8mdU1dP3iPV8NhGUdDcKcZIYx")
                
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // No one has read access to other peoples stuff
        defaultACL.publicReadAccess = false
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: false)
        
        if application.applicationState != UIApplicationState.Background {
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
  
        
        // Stripe Integration
        Stripe.setDefaultPublishableKey("pk_test_Ks6cqeQtnXJN0MQIkEOyAmKn")
        
        
    // -------------------------------
    // MARK: USER AUTO LOG IN
    // -------------------------------
//        if PFUser.currentUser() != nil {
//            
//            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoggedIn") as UIViewController
//            
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//            
//            let rootView: TierINavigationController = TierINavigationController()
//            
//        }
        
        return true
    }
    

    
    // -------------------------------
    // MARK: Push Notifcations
    // -------------------------------
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let chararacterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        let deviceTokenToPass = (deviceToken.description as NSString).stringByTrimmingCharactersInSet(chararacterSet).stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
        
        
        print("Device Token At AppDelegate: \(deviceToken)")
        print("DeviceTokenToPass At AppDelegate: \(deviceTokenToPass)")

        let installation = PFInstallation.currentInstallation()
        installation["deviceToken"] = deviceTokenToPass
        installation.saveInBackground()
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError.", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    
    // -------------------------------
    // MARK: Facebook SDK Integration
    // -------------------------------
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    // -------------------------------
    // MARK: Stock Delegate Functions
    // -------------------------------
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // ---------------------- Custom --
    func resetAppToFirstController() {
        
        
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Landing") as! ViewController

    }
    
    func resetToMenu() {
        
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Menu") as! UINavigationController
        
    }
    
}


