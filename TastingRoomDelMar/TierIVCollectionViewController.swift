//
//  TierIVCollectionViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/13/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import ParseCrashReporting

class TierIVCollectionViewController: PFQueryCollectionViewController {

    var varietalsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        varietalsQuery()
        

        self.collectionView?.reloadData()

    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// ---------------
// VARIETALS QUERY
// ---------------
    func varietalsQuery() {
        
        let query:PFQuery = PFQuery(className:"WineVarietals")
            query.includeKey("tag")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) varietals.")
                
                // Do something with the found objects
                for object in objects! as [PFObject]{
                    
                    if object["tag"]["state"] as! String == "active" {
                        
                        print(object["tag"]["state"])
                        self.varietalsArray.append(object["name"] as! String)
                        
                    }
                    
                }
                
                print("\(self.varietalsArray)")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            
        }
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return varietalsArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("varietalCell", forIndexPath: indexPath) as! TierIVCollectionViewCell
        
        cell.titleLabel?.backgroundColor = UIColor.lightGrayColor()
        cell.titleLabel?.layer.cornerRadius = 10.0
        cell.titleLabel?.clipsToBounds = true
        cell.titleLabel?.text = self.varietalsArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 3
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (4 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
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