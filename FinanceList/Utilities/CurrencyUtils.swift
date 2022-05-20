//
//  CurrencyUtils.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import Foundation

class CurrencyUtils {
    public class var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
    
    public class func formatToCurrencyString(amount: Decimal) -> String? {
        return numberFormatter.string(from: amount as NSDecimalNumber)
    }
}

