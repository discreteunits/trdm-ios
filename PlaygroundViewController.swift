//
//  PlaygroundViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 3/24/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

let notificationKey = "com.tastingroomdelmar.TastingRoomDelMar"

class PlaygroundViewController: UIViewController {

    @IBOutlet weak var notifiactionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotificationSentLabel", name: notificationKey, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func notify() {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: self)
    }
    
    func updateNotificationSentLabel() {
        self.notifiactionLabel.text = "Notification sent!"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func move(sender: AnyObject) {
        performSegueWithIdentifier("move", sender: self)
    }

}

