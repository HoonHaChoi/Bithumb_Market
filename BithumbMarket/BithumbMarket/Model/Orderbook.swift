//
//  Orderbook.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/28.
//

import Foundation

struct Quantity {
    let text: String
    let rate: Float
}

struct Orderbook {
    let asksPrice: [String]
    let bidsPrice: [String]
    let asksQuanity: [Quantity]
    let bidsQuanity: [Quantity]
}
