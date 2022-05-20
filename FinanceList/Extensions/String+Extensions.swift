//
//  String+Extensions.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/12/21.
//

import Foundation

public extension String {
    var asCurrency: String {
        return String(format: "$%.02f", self)
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
