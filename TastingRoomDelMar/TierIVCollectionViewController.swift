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

    var tierIVCollectionArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// TIER 4 COLLECTION QUERY
        tierIVCollectionQuery()
        
        self.collectionView?.reloadData()

    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// TIER 4 COLLECTION QUERY
    func tierIVCollectionQuery() {
        
        var className = String()
        
// COLLECTION CLASSNAME CONDITION
        if route[1]["name"] as! String == "Vines" {
            className = "WineVarietals"
        } else if route[1]["name"] as! String == "Hops" {
            className = "BeerStyles"
        }
        
        
        let query:PFQuery = PFQuery(className: className)
        query.includeKey("tier3")
        query.whereKey("tier3", equalTo: "\(route[2])")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                print("TierIV collection retrieved \(objects!.count) objects.")
                
                // Do something with the found objects
                for object in objects! as [PFObject]!{
                    
                    if object["tag"] != nil {
                        
                        if object["tier3"]["name"] as! String == route[2] {
                    
                            if object["tag"]["state"] as! String == "active" {
                            
                                self.tierIVCollectionArray.append(object)
                            
                            }
                        
                        }
                        
                    }
                    
                }
                
                self.collectionView?.reloadData()
                print("TIERIV COLLECTION ARRAY: \(self.tierIVCollectionArray)")
                
            } else {
                
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                
            }
            
        }
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tierIVCollectionArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tierIVCollectionCell", forIndexPath: indexPath) as! TierIVCollectionViewCell
        
        cell.titleLabel?.backgroundColor = UIColor.lightGrayColor()
        cell.titleLabel?.layer.cornerRadius = 10.0
        cell.titleLabel?.clipsToBounds = true
        cell.titleLabel?.text = self.tierIVCollectionArray[indexPath.row]["name"] as? String
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 3
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (4 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        route.append(tierIVCollectionArray[indexPath.row])
        print("THE ROUTE IS NOW: \(route)")
        
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