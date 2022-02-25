//
//  Orderbook.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

struct Orderbook: Decodable {
    let data: OrderbookData
}

struct OrderbookData: Decodable {
    let timestamp: String
    let orderCurrency: String
    let paymentCurrency: String
    let bids: [Currency]
    let asks: [Currency]
}

struct Currency: Decodable {
    let quantity: String
    let price: String
}
