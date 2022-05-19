//
//  Transaction.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/12/21.
//

import Foundation

public struct Transaction: Codable {
    var id: Int64?
    var date: String?
    var amount: Decimal?
    var isCredit: Bool?
    var description: String?
    var imageUrl: String?
}

public struct Transactions: Codable {
    var transactions: [Transaction]?
}
