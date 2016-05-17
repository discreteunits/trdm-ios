//
//  PriceFormatManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 4/6/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse

class PriceFormatManager: NSObject {

    static let priceFormatManager = PriceFormatManager()
    
    // To Use: PriceFormatManager.priceFormatManager.formatPrice(Double)
    func formatPrice (price: Double) -> String {
        let formatter = NSNumberFormatter()
//        formatter.numberStyle = .DecimalStyle
        
        // Format Digits
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2


        var convertedPrice = formatter.stringFromNumber(price)!

        let priceDecimals:Double = (price % 1)
        let priceDecimalsRounded = String(format:"%.2f", priceDecimals)
//        let priceDecimalsRounded = Double(round(10*priceDecimals)/10)

        if priceDecimalsRounded != "0.00" {
            if priceDecimalsRounded == "0.10" || priceDecimalsRounded == "0.20" ||
                priceDecimalsRounded == "0.30" || priceDecimalsRounded == "0.40" ||
                priceDecimalsRounded == "0.50" || priceDecimalsRounded == "0.60" ||
                priceDecimalsRounded == "0.70" || priceDecimalsRounded == "0.80" ||
                priceDecimalsRounded == "0.90" {
                convertedPrice = convertedPrice + "0"
            }
        }
            
        return convertedPrice

    }
}
