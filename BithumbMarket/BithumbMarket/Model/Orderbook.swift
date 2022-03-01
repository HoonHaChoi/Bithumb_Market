//
//  Orderbook.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/28.
//

import Foundation

struct Orderbook {
    var asks: [Order]
    var bids: [Order]
}

struct Order {
    let price: String
    let quantity: String
    let rateOfQuantity: Float
}
