//
//  SliderViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/29/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {

    var gratuityValue = String()
    var screenSize = CGRect()
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    @IBOutlet weak var gratuityValueLabel: UILabel!
    var gratuitySlider = UISlider()
    
    // Price Formatter
    let formatter = PriceFormatManager.priceFormatManager
    
    // ------
    override func viewWillAppear(animated: Bool) {
        
        gratuityValueLabel.text = "18%"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        gratuitySlider = UISlider(frame:CGRectMake(0, 0, screenWidth, 40))
        gratuitySlider.frame.origin.y = screenHeight / 4
        gratuitySlider.minimumValue = 0
        gratuitySlider.maximumValue = 100
        gratuitySlider.continuous = true
        gratuitySlider.tintColor = UIColor.primaryGreenColor()
        gratuitySlider.value = 18
        gratuitySlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(gratuitySlider)
    
    }

    func sliderValueDidChange(sender:UISlider!) {
        
        var output = Int(sender.value)
        gratuitySlider.value = Float(output)
        
        print("Gratuity Value: \(sender.value)")
        gratuityValueLabel.text = String(output) + "%"
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
