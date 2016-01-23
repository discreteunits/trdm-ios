//
//  TierIVTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/13/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse

@objc
protocol TierIVTableViewDelegate {
    func tagsArrayCreation()
    func tierIVCollectionQuery()
    func tierIVTableQuery()
}

class TierIVTableViewController: UITableViewController {
    
    var TierIVViewControllerRef: TierIVViewController?
    var TierIVCollectionViewControllerRef: TierIVCollectionViewController?
    
    var delegate: TierIVTableViewDelegate?
    
    
    var tierIVCollectionArray: [PFObject]!
    var collectionArray = [PFObject]() {
        didSet {
            tierIVCollectionArray = collectionArray
        }
    }
    
    var tierIVTableArray: [PFObject]!
    var tableArray = [PFObject]() {
        didSet {
            tierIVTableArray = tableArray
        }
    }

    
// ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tierIVTableArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! TierIVTableViewCell

//        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
            cell.itemNameLabel?.text = self.tierIVTableArray[indexPath.row]["name"] as! String?
            cell.altNameLabel?.text = self.tierIVTableArray[indexPath.row]["alternateName"] as! String?
            
        
        dispatch_async(dispatch_get_main_queue()) {

            if let itemTags = self.tierIVTableArray[indexPath.row]["tags"] as? [PFObject] {
                print("ITEM TAGS IS====== \(itemTags)")
                print("COLLECTION ARRAY IS ====== \(self.tierIVCollectionArray)")
                for tagObject in itemTags {
                
                    print("$$$$$$$$$ \(tagObject)")
                    
                    
                    if self.tierIVCollectionArray.contains(tagObject) {
                        print("TWO")

                        cell.varietalLabel?.text = tagObject["name"] as? String
                    
                    }
                
                }
            
            }
        }
        
        
        
        
        return cell
    }
    
    
}
