//
//  PriceFormatManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/6/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit

class PriceFormatManager: NSObject {

    static let priceFormatManager = PriceFormatManager()
    
    // To Use: PriceFormatManager.priceFormatManager.formatPrice(Double)
    func formatPrice (price: Double) -> String {
        let formatter = NSNumberFormatter()
        
        // Format Digits
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        var convertedPrice = String()

        
        if ( price - floor(price) > 0.1 && price - floor(price) < 0 ) {
            let convertPrice = formatter.stringFromNumber(price)
            convertedPrice = convertPrice!
            
            return convertedPrice
            
        } else {
            convertedPrice = formatter.stringFromNumber(price)!
            
            return convertedPrice
            
        }
        
        return convertedPrice
        
    }
    
}
