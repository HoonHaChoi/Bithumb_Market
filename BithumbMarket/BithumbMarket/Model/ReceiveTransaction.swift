//
//  ReceiveTransaction.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/01.
//

import Foundation

struct ReceiveTransaction: Codable {
    let type: String
    let content: Content
}

struct Content: Codable {
    let list: [TransactionList]
}

struct TransactionList: Codable {
    let buySellGb: String
    let contPrice: String
    let contQty: String
    let contAmt: String
    let contDtm: String
    let updn: String
    let symbol: String
}
