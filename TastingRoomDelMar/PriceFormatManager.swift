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
        formatter.numberStyle = .DecimalStyle
        
        // Format Digits
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2


        var convertedPrice = formatter.stringFromNumber(price)!

        let priceDecimals:Double = (price % 1)
        if priceDecimals != 0 {
            if priceDecimals == 0.1 || priceDecimals == 0.2 ||
                priceDecimals == 0.3 || priceDecimals == 0.4 ||
                priceDecimals == 0.5 || priceDecimals == 0.6 ||
                priceDecimals == 0.7 || priceDecimals == 0.8 ||
                priceDecimals == 0.9 {
                convertedPrice = convertedPrice + "0"
            }
        }
            
            return convertedPrice

    }
}
