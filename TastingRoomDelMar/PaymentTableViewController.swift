//
//  PaymentTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/8/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse



class PaymentTableViewController: UITableViewController {
    
    var rows = Int()
    
    // Table Row Indicators
    var addPaymentRow: Int!
    
    
    // -----------
    override func viewWillAppear(animated: Bool) {
        
        CardManager.sharedInstance.getCards()
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        
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

        if CardManager.sharedInstance.currentCustomer.card.last4 != "" {
            rows = 2
        } else {
            rows = 1
        }
        
        addPaymentRow = rows - 1
        
        return rows
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        // Card Row
        if indexPath.row < addPaymentRow {
            let cardCell = tableView.dequeueReusableCellWithIdentifier("PaymentCardTableCell", forIndexPath: indexPath) as! PaymentCardTableViewCell
            
            // Assignments
            cardCell.providerLabel.text = CardManager.sharedInstance.currentCustomer.card.brand
            cardCell.lastFourLabel.text = CardManager.sharedInstance.currentCustomer.card.last4
            
            cardCell.providerLabel.font = UIFont.headerFont(22)
            cardCell.lastFourLabel.font = UIFont.headerFont(22)
            
            
            // Styles
            cardCell.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
            cardCell.layer.borderWidth = 1.0
            cardCell.layer.borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).CGColor
            
            return cardCell
            
        // Add Payment Row
        } else if indexPath.row == addPaymentRow {
            let addCell = tableView.dequeueReusableCellWithIdentifier("PaymentAddCardTableCell", forIndexPath: indexPath) as! PaymentAddCardTableViewCell
            
            if CardManager.sharedInstance.currentCustomer.card.brand != "" {
                addCell.addPaymentLabel.text = "+  Change Payment"
            } else {
                addCell.addPaymentLabel.text = "+  Add Payment"
            }
            
            addCell.addPaymentLabel.font = UIFont.headerFont(18)

            
            addCell.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
            addCell.layer.borderWidth = 1.0
            addCell.layer.borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).CGColor
            
            return addCell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Card Row
        if indexPath.row < addPaymentRow {
            
            // Edit Card
            
        // Add Payment Row
        } else if indexPath.row == addPaymentRow {

            performSegueWithIdentifier("addPayment", sender: self)
            
        }
        
    }
 
}
