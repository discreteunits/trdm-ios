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
        
//        if (price - floor(price) > 0.1) {
//            convertedPrice = formatter.stringFromNumber(price)!
//            
//            return convertedPrice
//        } else if (price - floor(price) > 0) {
//            let convertPrice = formatter.stringFromNumber(price)
//            convertedPrice = convertPrice! + "0"
//            
//            return convertedPrice
//            
//        }
        
        
        if (price - floor(price) > 0.1) {
            let convertPrice = formatter.stringFromNumber(price)
            convertedPrice = convertPrice! + "0"
            
            return convertedPrice
            
        } else {
            convertedPrice = formatter.stringFromNumber(price)!
            
            return convertedPrice
            
        }
        
        return convertedPrice
        
    }
    
}
