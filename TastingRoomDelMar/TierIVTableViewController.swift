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
    
    var tableContainerViewController: TierIVViewController?
    
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
        
        print("TierIV table view has recieved: \(tierIVTableArray)")

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
        
        
        
        
        cell.itemNameLabel?.text = tierIVTableArray[indexPath.row]["name"] as! String?
        cell.altNameLabel?.text = tierIVTableArray[indexPath.row]["alternateName"] as! String?
        
        
        if let itemTags = tierIVTableArray[indexPath.row]["tags"] as? [PFObject] {
            print("ITEM TAGS IS====== \(itemTags)")
            print("COLLECTION ARRAY IS ====== \(collectionArray)")
            for tagObject in itemTags {
                
                if collectionArray.contains(tagObject) {
                    print("TWO")

                    cell.varietalLabel?.text = tagObject["name"] as? String
                    
                }
                
            }
            
        }
    
        return cell
    }
    
    
// WHAT VARIETAL IS EACH ITEM ???
    func itemVarietal(itemObject: AnyObject) -> PFObject {
        
        var itemVarietalObject = PFObject()
        
        if itemObject["tags"] != nil {
        
        if let itemTags = itemObject["tags"] as? [PFObject] {
            
            for tagObject in itemTags {
                
                if tierIVTableArray.contains(tagObject) {
                    
                    itemVarietalObject = tagObject
                    
                }
                
            }
            
        }
        }
        
        return itemVarietalObject
        
    }
    
    
}
