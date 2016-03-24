//
//  PlaygroundTwoViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 3/24/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class PlaygroundTwoViewController: UIViewController {

    
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = NSNotificationCenter.defaultCenter()
        print("\(data)")
        

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnSpecialNotification", name: notificationKey, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func actOnSpecialNotification() {
        self.notificationLabel.text = "I heard the notification!"
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
