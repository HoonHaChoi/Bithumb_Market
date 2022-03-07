//
//  Transaction.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/25.
//

import Foundation

struct Transaction: Decodable {
    let status: String
    let data: [TransactionData]
}

struct TransactionData: Decodable {
    let transactionDate: String
    let type: String
    let unitsTraded: String
    let price: String
    let total: String
}
